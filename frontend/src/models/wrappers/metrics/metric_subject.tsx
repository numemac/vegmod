import { Wrapper } from "../../wrapper";

import Metric from "@/models/wrappers/metrics/metric";
import MetricSubjectDataPoint from "@/models/wrappers/metrics/metric_subject_data_point";

export default class MetricSubject extends Wrapper {

    get dataPoints() : MetricSubjectDataPoint[] {
        return this.get("data_points");
    }

    get metric() : Metric {
        return this.get("metric");
    }

}