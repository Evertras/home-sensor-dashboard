package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/cucumber/godog"
)

var (
	envTableName string
	envBaseURL   string
)

func init() {
	mustEnv := func(key string) string {
		val := os.Getenv(key)
		if val == "" {
			panic(fmt.Errorf("missing environment variable %q", key))
		}
		return val
	}

	envTableName = mustEnv("TEST_DYNAMODB_TABLE")
	envBaseURL = mustEnv("TEST_BASE_URL")
}

type testContext struct {
	db *dynamodb.Client

	httpClient   *http.Client
	lastResponse *http.Response
}

func newTestContext(db *dynamodb.Client) *testContext {
	return &testContext{
		db: db,
		httpClient: &http.Client{
			Timeout: time.Second * 5,
		},

		lastResponse: nil,
	}
}

func (t *testContext) theStatusCodeShouldBe(code int) error {
	if t.lastResponse == nil {
		return fmt.Errorf("no response tracked")
	}

	if t.lastResponse.StatusCode != code {
		return fmt.Errorf(
			"expected status code %d but got %d",
			code,
			t.lastResponse.StatusCode,
		)
	}

	return nil
}

func InitializeScenario(sc *godog.ScenarioContext) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	var t *testContext

	cfg, err := config.LoadDefaultConfig(ctx, config.WithRegion("ap-northeast-1"))

	if err != nil {
		panic(fmt.Errorf("config.LoadDefaultConfig: %w", err))
	}

	db := dynamodb.NewFromConfig(cfg)

	t = newTestContext(db)

	sc.Step(`^the sensor named "([a-zA-Z0-9-]+)" has no previous data$`, t.hasNoPreviousData)
	sc.Step(`^the sensor named "([a-zA-Z0-9-]+)" sends a (temperature) measurement of (\d+)$`, t.sensorSendsMeasurement)
	sc.Step(`^I request the latest (temperature) measurement for "([a-zA-Z0-9-]+)"$`, t.requestLatestMeasurement)
	sc.Step(`^the measurement should equal (\d+)$`, t.measurementShouldBe)
	sc.Step(`^the measurement should not be found$`, t.measurementShouldNotBeFound)
	sc.Step(`^I call the dummy endpoint$`, t.iCallTheDummyEndpoint)
	sc.Step(`^the status code should be (\d+)$`, t.theStatusCodeShouldBe)
}
