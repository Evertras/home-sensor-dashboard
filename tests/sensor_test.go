package main

import (
	"context"
	"fmt"
	"os"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"github.com/cucumber/godog"
)

type sensorApi struct {
	db        *dynamodb.Client
	tableName string
}

func newSensorApi(db *dynamodb.Client, tableName string) *sensorApi {
	return &sensorApi{
		db,
		tableName,
	}
}

func (t *sensorApi) hasNoPreviousData(name string) error {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)
	defer cancel()

	_, err := t.db.DeleteItem(ctx, &dynamodb.DeleteItemInput{
		Key: map[string]types.AttributeValue{
			"SensorID": &types.AttributeValueMemberS{
				Value: name,
			},
		},
		TableName: aws.String(t.tableName),
	})

	if err != nil {
		return fmt.Errorf("t.db.DeleteItem: %w", err)
	}

	return nil
}

func (t *sensorApi) sensorSendsMeasurement(kind string, measurement int) error {
	return godog.ErrPending
}

func (t *sensorApi) requestLatestMeasurement(sensor string, kind string) error {
	return godog.ErrPending
}

func (t *sensorApi) measurementShouldBe(value int) error {
	return godog.ErrPending
}

func InitializeScenario(sc *godog.ScenarioContext) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	var api *sensorApi
	tableName := os.Getenv("TEST_DYNAMODB_TABLE")

	if tableName == "" {
		panic(fmt.Errorf("missing TEST_DYNAMODB_TABLE"))
	}

	cfg, err := config.LoadDefaultConfig(ctx, config.WithRegion("ap-northeast-1"))

	if err != nil {
		panic(fmt.Errorf("config.LoadDefaultConfig: %w", err))
	}

	db := dynamodb.NewFromConfig(cfg)

	api = newSensorApi(db, tableName)

	sc.Step(`^the sensor named "([a-zA-Z0-9-]+)" has no previous data$`, api.hasNoPreviousData)
	sc.Step(`^the sensor sends a (temperature) measurement of (\d+)$`, api.sensorSendsMeasurement)
	sc.Step(`^I request the latest (temperature) measurement for "([a-zA-Z0-9-]+)"$`, api.requestLatestMeasurement)
	sc.Step(`^the measurement should equal (\d+)$`, api.measurementShouldBe)
}
