package main

import (
	"bytes"
	"context"
	"fmt"
	"net/http"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"github.com/cucumber/godog"
)

func (t *testContext) hasNoPreviousData(name string) error {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)
	defer cancel()

	_, err := t.db.DeleteItem(ctx, &dynamodb.DeleteItemInput{
		Key: map[string]types.AttributeValue{
			"SensorID": &types.AttributeValueMemberS{
				Value: name,
			},
		},
		TableName: aws.String(envTableName),
	})

	if err != nil {
		return fmt.Errorf("t.db.DeleteItem: %w", err)
	}

	return nil
}

func (t *testContext) sensorSendsMeasurement(sensor, kind string, measurement int) error {
	url := fmt.Sprintf("%s/sensor/%s/%s", envBaseURL, sensor, kind)

	body := bytes.NewBufferString(fmt.Sprintf("%d", measurement))

	res, err := t.httpClient.Post(url, "text/plain", body)

	if err != nil {
		return fmt.Errorf("t.httpClient.Post: %w", err)
	}

	if res.StatusCode/100 != 2 {
		return fmt.Errorf("expected status code 2xx, got %d", res.StatusCode)
	}

	t.lastResponse = res

	return nil
}

func (t *testContext) requestLatestMeasurement(sensor string, kind string) error {
	url := fmt.Sprintf("%s/sensor/%s/%s", envBaseURL, sensor, kind)
	res, err := t.httpClient.Get(url)

	if err != nil {
		return fmt.Errorf("t.httpClient.Get: %w", err)
	}

	t.lastResponse = res

	return nil
}

func (t *testContext) measurementShouldBe(value int) error {
	if t.lastResponse == nil {
		return fmt.Errorf("no response tracked, probably test failure")
	}

	return godog.ErrPending
}

func (t *testContext) measurementShouldNotBeFound() error {
	if t.lastResponse == nil {
		return fmt.Errorf("no response tracked, probably test failure")
	}

	if t.lastResponse.StatusCode != http.StatusNotFound {
		return fmt.Errorf("expected status code %d but got %d", http.StatusNotFound, t.lastResponse.StatusCode)
	}

	return nil
}
