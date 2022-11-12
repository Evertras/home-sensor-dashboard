package remote

import (
	"context"
	"fmt"
	"net/http"
)

func (p *Provider) CallDummy(ctx context.Context) (*http.Response, error) {
	url := fmt.Sprintf("%s/dummy", p.baseURL)

	res, err := p.httpClient.Get(url)

	if err != nil {
		return nil, fmt.Errorf("failed to GET: %w", err)
	}

	return res, nil
}
