package remote

import (
	"context"
	"fmt"
	"net/http"
	"time"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

type Provider struct {
	db *dynamodb.Client

	httpClient *http.Client

	tableName string
	baseURL   string
}

func New(baseURL, tableName string) *Provider {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()

	cfg, err := config.LoadDefaultConfig(ctx, config.WithRegion("ap-northeast-1"))

	if err != nil {
		panic(fmt.Errorf("remote config.LoadDefaultConfig: %w", err))
	}

	return &Provider{
		db: dynamodb.NewFromConfig(cfg),

		httpClient: &http.Client{
			Timeout: time.Second * 5,
		},

		tableName: tableName,
		baseURL:   baseURL,
	}
}
