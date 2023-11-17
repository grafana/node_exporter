// Copyright 2023 The Prometheus Authors
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//go:build linux && !nosoftirqs
// +build linux,!nosoftirqs

package collector

import (
	"fmt"

	"github.com/go-kit/log"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/procfs"
)

type softirqsCollector struct {
	fs     procfs.FS
	desc   typedDesc
	logger log.Logger
}

func init() {
	registerCollector("softirqs", defaultDisabled, NewSoftirqsCollector)
}

// NewSoftirqsCollector returns a new Collector exposing softirq stats.
func NewSoftirqsCollector(config *NodeCollectorConfig, logger log.Logger) (Collector, error) {
	desc := typedDesc{prometheus.NewDesc(
		namespace+"_softirqs_functions_total",
		"Softirq counts per CPU.",
		softirqLabelNames, nil,
	), prometheus.CounterValue}

	fs, err := procfs.NewFS(*config.Path.ProcPath)
	if err != nil {
		return nil, fmt.Errorf("failed to open procfs: %w", err)
	}

	return &softirqsCollector{fs, desc, logger}, nil
}
