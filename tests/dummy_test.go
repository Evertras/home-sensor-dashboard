package main

import (
	"fmt"
	"net/http"
)

func (t *testContext) iCallTheDummyEndpoint() error {
	url := fmt.Sprintf("%s/dummy", envBaseURL)

	res, err := http.Get(url)

	if err != nil {
		return fmt.Errorf("failed to GET: %w", err)
	}

	if res.StatusCode != http.StatusOK {
		return fmt.Errorf("unexpected status code: expected %d, got %d", http.StatusOK, res.StatusCode)
	}

	t.lastResponse = res

	return nil
}
