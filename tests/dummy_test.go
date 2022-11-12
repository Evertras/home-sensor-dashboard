package main

import (
	"context"
	"fmt"
	"net/http"
	"time"
)

type dummyCaller interface {
	CallDummy(ctx context.Context) (*http.Response, error)
}

func (t *testContext) iCallTheDummyEndpoint() error {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)
	defer cancel()

	res, err := t.provider.CallDummy(ctx)

	if err != nil {
		return fmt.Errorf("t.provider.CallDummy: %w", err)
	}

	if res.StatusCode != http.StatusOK {
		return fmt.Errorf("unexpected status code: expected %d, got %d", http.StatusOK, res.StatusCode)
	}

	t.lastResponse = res

	return nil
}
