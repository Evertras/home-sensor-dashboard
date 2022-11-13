package remote

import (
	"context"
	"fmt"
	"net/http"
)

func (p *Provider) GetSimpleSite(ctx context.Context) (*http.Response, error) {
	url := p.baseURL + "/"

	req, err := http.NewRequest("GET", url, nil)

	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}

	req = req.WithContext(ctx)

	res, err := p.httpClient.Do(req)

	if err != nil {
		return nil, fmt.Errorf("remote p.httpClient.Do: %w", err)
	}

	return res, nil
}
