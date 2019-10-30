
provider "google" {
    project = "istio-test-256600"

}

resource "google_monitoring_notification_channel" "jeff_email" {
  display_name = "Jeff"
  type = "email"
  labels = {
    email_address = "jeffling@google.com"
  }
}

resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "Service Latency"
  combiner = "OR"
  conditions {
    display_name = "trigger condition"
    condition_threshold {
      filter = "metric.type=\"istio.io/service/client/roundtrip_latencies\" AND resource.type=\"k8s_pod\""
      duration = "60s"
      threshold_value = "1500"
      comparison = "COMPARISON_GT"
      aggregations {
	alignment_period = "60s"
        per_series_aligner = "ALIGN_PERCENTILE_99"    
      }
    }
  }
  notification_channels = [
    "${google_monitoring_notification_channel.jeff_email.name}",
  ]

}
