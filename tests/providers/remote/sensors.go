package remote

import (
	"bytes"
	"context"
	"fmt"
	"net/http"
)

func (p *Provider) ClearSensor(ctx context.Context, sensorName string) error {
	measurementsToClear := []string{"temperaturec", "humidity100"}

	for _, measurementType := range measurementsToClear {
		err := p.deleteSensorData(ctx, sensorName, measurementType)
		if err != nil {
			return fmt.Errorf("dev p.db.DeleteItem for sensor %q and measurement %q: %w", sensorName, measurementType, err)
		}
	}

	return nil
}

func (p *Provider) SendMeasurement(ctx context.Context, sensorName, kind string, measurement int) (*http.Response, error) {
	url := fmt.Sprintf("%s/sensor/%s/%s", p.baseURL, sensorName, kind)

	body := bytes.NewBufferString(fmt.Sprintf(`{"value": %d}`, measurement))

	req, err := http.NewRequest("PUT", url, body)

	if err != nil {
		return nil, fmt.Errorf("remote failed to create request: %w", err)
	}

	req = req.WithContext(ctx)

	req.Header.Add("content-type", "application/json")

	res, err := p.httpClient.Do(req)

	if err != nil {
		return nil, fmt.Errorf("remote p.httpClient.Do for %q: %w", url, err)
	}

	return res, nil
}

func (p *Provider) RequestLatestMeasurement(ctx context.Context, sensorName, kind string) (*http.Response, error) {
	url := fmt.Sprintf("%s/sensor/%s/%s", p.baseURL, sensorName, kind)

	req, err := http.NewRequest("GET", url, nil)

	if err != nil {
		return nil, fmt.Errorf("remote failed to create request: %w", err)
	}

	res, err := p.httpClient.Do(req)

	if err != nil {
		return nil, fmt.Errorf("remote p.httpClient.Do for %q: %w", url, err)
	}

	return res, nil
}
