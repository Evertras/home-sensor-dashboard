package remote

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

func (p *Provider) deleteSensorData(ctx context.Context, sensorName, measurementKind string) error {
	_, err := p.db.DeleteItem(ctx, &dynamodb.DeleteItemInput{
		Key: map[string]types.AttributeValue{
			"SensorID": &types.AttributeValueMemberS{
				Value: sensorName,
			},
			"MeasurementType": &types.AttributeValueMemberS{
				Value: measurementKind,
			},
		},
		TableName: aws.String(p.tableName),
	})

	return err
}
