package selectgame

import (
	"context"
	"fmt"
	"io"
	"net/http"
	"cloud.google.com/go/pubsub"
)

// HTTP Cloud Function.
func SelectGame(w http.ResponseWriter, r *http.Request) {
	projectID := "mamecloud"
	topic := "game-request"
	romName := "rtypeleo"
	err := publish(w, projectID, topic, romName)
	if err!=nil {
		fmt.Fprint(w, "Request failed")
	}
}

func publish(w io.Writer, projectID, topicID, msg string) error {

	ctx := context.Background()
	client, err := pubsub.NewClient(ctx, projectID)
	if err != nil {
			return fmt.Errorf("pubsub.NewClient: %v", err)
	}

	t := client.Topic(topicID)
	result := t.Publish(ctx, &pubsub.Message{
			Data: []byte(msg),
	})

	// Block until the result is returned and a server-generated
	// ID is returned for the published message.
	id, err := result.Get(ctx)
	if err != nil {
			return fmt.Errorf("Get: %v", err)
	}

	fmt.Fprintf(w, "Published a message; msg ID: %v\n", id)
	return nil
}