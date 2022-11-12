package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

type sensorRepository interface {
	ClearSensor(ctx context.Context, sensorName string) error
	SendMeasurement(ctx context.Context, sensorName, kind string, measurement int) (*http.Response, error)
	RequestLatestMeasurement(ctx context.Context, sensorName, kind string) (*http.Response, error)
}

func (t *testContext) hasNoPreviousData() error {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)
	defer cancel()

	err := t.provider.ClearSensor(ctx, t.sensorName)

	if err != nil {
		return fmt.Errorf("t.provider.ClearSensor: %w", err)
	}

	return nil
}

func (t *testContext) sensorSendsBadMeasurement(kind string, measurement int) error {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)
	defer cancel()

	var err error
	t.lastResponse, err = t.provider.SendMeasurement(ctx, t.sensorName, kind, measurement)

	if err != nil {
		return fmt.Errorf("t.provider.SendMeasurement: %w", err)
	}

	return nil
}

func (t *testContext) sensorSendsMeasurement(kind string, measurement int) error {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)
	defer cancel()

	var err error
	t.lastResponse, err = t.provider.SendMeasurement(ctx, t.sensorName, kind, measurement)

	if err != nil {
		return fmt.Errorf("t.provider.SendMeasurement: %w", err)
	}

	if t.lastResponse.StatusCode/100 != 2 {
		return fmt.Errorf("expected status code 2xx, got %d", t.lastResponse.StatusCode)
	}

	return nil
}

func (t *testContext) requestLatestMeasurement(kind, sensor string) error {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)
	defer cancel()

	var err error
	t.lastResponse, err = t.provider.RequestLatestMeasurement(ctx, sensor, kind)

	if err != nil {
		return fmt.Errorf("t.provider.RequestLatestMeasurement: %w", err)
	}

	return nil
}

func (t *testContext) measurementShouldBe(value int) error {
	if t.lastResponse == nil {
		return fmt.Errorf("no response tracked, probably test failure")
	}

	contents, err := io.ReadAll(t.lastResponse.Body)

	if err != nil {
		return fmt.Errorf("io.ReadAll: %w", err)
	}

	var response struct {
		Value int `json:"value"`
	}

	err = json.Unmarshal(contents, &response)

	if err != nil {
		return fmt.Errorf("json.Unmarshal: %w", err)
	}

	if response.Value != value {
		return fmt.Errorf("expected value %d but got %d", value, response.Value)
	}

	return nil
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
