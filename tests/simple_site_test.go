package main

import (
	"context"
	"fmt"
	"net/http"
	"time"
)

type simpleSiteGetter interface {
	GetSimpleSite(ctx context.Context) (*http.Response, error)
}

func (t *testContext) iRequestTheSimpleSite() error {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)
	defer cancel()

	var err error
	t.lastResponse, err = t.provider.GetSimpleSite(ctx)

	if err != nil {
		return fmt.Errorf("t.provider.GetSimpleSite: %w", err)
	}

	return nil
}
