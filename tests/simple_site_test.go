package main

import (
	"context"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"

	"github.com/cucumber/godog"
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

func (t *testContext) thePageShouldContainData(data *godog.Table) error {
	// TODO: should just store body on read, but for now...
	raw, err := io.ReadAll(t.lastResponse.Body)

	if err != nil {
		return fmt.Errorf("failed to read body: %w", err)
	}

	body := string(raw)
	notFound := []string{}

	// TODO: Parsing HTTP body is out of scope, just bare minimum check for now
	for _, row := range data.Rows {
		for _, cell := range row.Cells {
			if !strings.Contains(body, cell.Value) {
				notFound = append(notFound, cell.Value)
			}
		}
	}

	if len(notFound) > 0 {
		return fmt.Errorf("missing expected values: %s", strings.Join(notFound, ", "))
	}

	return nil
}
