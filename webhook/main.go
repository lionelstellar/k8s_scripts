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
	node_ip := []string{"172.16.238.138", "172.16.238.136"}
	control_plane := []string{"kubelet", "kube-scheduler", "kube-probe",
		"kube-proxy", "kube-scheduler", "kube-apiserver", "coredns",
		"kube-controller-manager", "kubectl", "flanneld"}

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

			// if test(event) {
			// 	fmt.Printf("event detected: \n%+v\n", event)
			// 	fmt.Printf("verb: %s\n\n", event.Verb)
			// }
			// event.Verb == "delete"

			// capture curl event
			if podAccessApiServer(event, control_plane, node_ip) {
				fmt.Printf("pod Access ApiServer Event detected:\n %+v\n\n", event)
				fmt.Print("Src:", event.SourceIPs[0])
				// fmt.Print("code:", event.ResponseStatus.Code)
				fmt.Print("UserAgent: ", event.UserAgent)
				fmt.Printf("\n\n")
			}

			// abnormal connection
			// if isUnauthenticated(event) || isUnauthorized(event) {
			// 	fmt.Printf("Unauthenticated or Unauthorized Event detected: %+v\n\n", event)
			// 	fmt.Print("Src", event.SourceIPs)
			// 	fmt.Printf("\n\n")
			// }

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
		event.ObjectRef.Resource == "podsecuritypolicies"
}

func isUnauthenticated(event v1.Event) bool {
	return event.ResponseStatus.Code == 401
}

func isUnauthorized(event v1.Event) bool {
	return event.ResponseStatus.Code == 403
}

func isSysUserAgent(event v1.Event, sys_agent_array []string) bool {
	return contains_in(event.UserAgent, sys_agent_array)
}

func isClusterIP(event v1.Event, cluster_ip_array []string) bool {
	return in(event.SourceIPs[0], cluster_ip_array)
}

func podAccessApiServer(event v1.Event, sys_agent_array []string, cluster_ip_array []string) bool {
	return isClusterIP(event, cluster_ip_array) && (!isSysUserAgent(event, sys_agent_array))
}

// return true if target in str_array
func in(target string, str_array []string) bool {
	for _, element := range str_array {
		if target == element {
			return true
		}
	}
	return false
}

// return true if target contains any elem of int the str_array
func contains_in(target string, str_array []string) bool {
	for _, element := range str_array {
		if strings.Contains(target, element) {
			return true
		}
	}
	return false
}
