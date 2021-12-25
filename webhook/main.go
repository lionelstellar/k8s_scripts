package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strings"

	v1 "k8s.io/apiserver/pkg/apis/audit/v1"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()
		body, err := ioutil.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "failed to read body", http.StatusBadRequest)
			return
		}

		var events v1.EventList
		err = json.Unmarshal(body, &events)
		if err != nil {
			http.Error(w, "failed to unmarshal audit events", http.StatusBadRequest)
			return
		}
		// Iterate and filter audit events
		for _, event := range events.Items {
			// if isPodCreation(event) {
			// 	fmt.Printf("Pod creation event detected: \n%+v\n", event)
			// }

			// if isPodDelete(event) {
			// 	fmt.Printf("Pod delete event detected: \n%+v\n", event)
			// }

			// if isConfigMap(event) {
			// 	fmt.Printf("ConfigMap event detected: \n%+v\n", event)
			// }
			// if isSecretList(event) {
			// 	fmt.Printf("list secret event detected: \n%+v\n", event)
			// }

			// if isCronjobChange(event) {
			// 	fmt.Printf("cronjob change event detected: \n%+v\n", event)
			// }

			if test(event) {
				fmt.Printf("event detected: \n%+v\n", event)
				fmt.Printf("verb: %s\n\n", event.Verb)
			}

			// fmt.Printf("Event detected: %+v\n\n", event)

		}
	})

	fmt.Printf("Starting server at port 8080\n")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}

// isPodCreation returns true if the given event is of a pod creation
func isPodCreation(event v1.Event) bool {
	return event.Verb == "create" &&
		event.Stage == v1.StageResponseComplete &&
		event.ObjectRef != nil &&
		event.ObjectRef.Resource == "pods"
}

// isPodCreation returns true if the given event is of a pod creation
func isPodDelete(event v1.Event) bool {
	return event.Verb == "delete" &&
		event.Stage == v1.StageResponseComplete &&
		event.ObjectRef != nil &&
		event.ObjectRef.Resource == "pods"
}

func isPodEvent(event v1.Event) bool {
	return event.Stage == v1.StageResponseComplete &&
		event.ObjectRef != nil &&
		event.ObjectRef.Resource == "pods"
}

// isPodCreation returns true if the given event is of a pod creation
func isConfigMap(event v1.Event) bool {
	return event.Verb != "watch" &&
		event.ObjectRef != nil &&
		event.ObjectRef.Resource == "configmaps"
}

// isPodCreation returns true if the given event is of a pod creation
func isSecretList(event v1.Event) bool {
	return event.Verb == "list" &&
		event.ObjectRef != nil &&
		event.ObjectRef.Resource == "secrets"
}

// isPodCreation returns true if the given event is of a pod creation
func isCronjobChange(event v1.Event) bool {
	return event.Verb == "patch" &&
		event.ObjectRef != nil &&
		event.ObjectRef.Resource == "cronjobs"
}

func test(event v1.Event) bool {
	return strings.Split(event.UserAgent, "/")[0] == "kubectl" &&
		event.ObjectRef != nil &&
		event.ObjectRef.Resource == "clusterrolebindings"
}
