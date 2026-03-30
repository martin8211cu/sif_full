<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>

<div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>

<script>
    
Highcharts.chart('container', {
    chart: {
        type: 'area',
        animation: Highcharts.svg, // don't animate in old IE
        marginRight: 10,
        events: {
            load: function () {

                // set up the updating of the chart each second
                var series0 = this.series[0];
                var series1 = this.series[1];
                var series2 = this.series[2];
                var series3 = this.series[3];
                setInterval(function () {
                    
                    $.ajax({
                        url: '/cfmx/home/public/mem_monitor/serverload.cfc?method=getMemData',
                        type: "GET",
                        dataType: "json",
                        data : {username : "demo"},
                        success: function(data) {
                            data.forEach(element => {
                                var x = (new Date()).getTime(), // current time
                                    y = element.VALUE;
                                    console.log(element.NAME);
                                if(element.NAME == 'Max Memory') {
                                    series0.addPoint([x, y], true, true);
                                } else if(element.NAME == 'Total Memory') {
                                    series1.addPoint([x, y], true, true);
                                } else if(element.NAME == 'Free Memory') {
                                    series2.addPoint([x, y], true, true);
                                } else if(element.NAME == 'Used Memory') {
                                    series3.addPoint([x, y], true, true);
                                }
                            });
                            /*chart.addSeries({
                            name: "mentions",
                            data: data.month_mentions_graphic
                            });*/
                        },
                        cache: false
                    });
                }, 10000);
            }
        }
    },

    time: {
        useUTC: false
    },

    title: {
        text: 'Live random data'
    },
    xAxis: {
        type: 'datetime',
        tickPixelInterval: 150
    },
    yAxis: {
        title: {
            text: 'Value'
        },
        plotLines: [{
            value: 0,
            width: 1,
            color: '#808080'
        }]
    },
    tooltip: {
        headerFormat: '<b>{series.name}</b><br/>',
        pointFormat: '{point.x:%Y-%m-%d %H:%M:%S}<br/>{point.y:.2f}'
    },
    legend: {
        enabled: true
    },
    exporting: {
        enabled: false
    },
    plotOptions: {
        area: {
            pointStart: 1940,
            marker: {
                enabled: false,
                symbol: 'circle',
                radius: 2,
                states: {
                    hover: {
                        enabled: true
                    }
                }
            }
        }
    },
    series: [{
        name: 'Max Memory',
        data: (function () {
            // generate an array of random data
            var data = [],
                time = (new Date()).getTime(),
                i;

            for (i = -20; i <= 0; i += 1) {
                data.push({
                    x: time + i * 1000,
                    y: 0
                });
            }
            return data;
        }())
    },
    {
        name: 'Total Memory Allocated',
        data: (function () {
            // generate an array of random data
            var data = [],
                time = (new Date()).getTime(),
                i;

            for (i = -20; i <= 0; i += 1) {
                data.push({
                    x: time + i * 1000,
                    y: 0
                });
            }
            return data;
        }())
    },
    {
        name: 'Free Allocated Memory',
        data: (function () {
            // generate an array of random data
            var data = [],
                time = (new Date()).getTime(),
                i;

            for (i = -20; i <= 0; i += 1) {
                data.push({
                    x: time + i * 1000,
                    y: 0
                });
            }
            return data;
        }())
    },
    {
        name: 'Used Memory',
        data: (function () {
            // generate an array of random data
            var data = [],
                time = (new Date()).getTime(),
                i;

            for (i = -20; i <= 0; i += 1) {
                data.push({
                    x: time + i * 1000,
                    y: 0
                });
            }
            return data;
        }())
    }]
});

function requestData() {
    $.ajax({
        url: '/cfmx/home/public/mem_monitor/serverload.cfc?method=getMemData',
        type: "GET",
        dataType: "json",
        data : {username : "demo"},
        success: function(data) {
            return data;
            /*chart.addSeries({
              name: "mentions",
              data: data.month_mentions_graphic
            });*/
        },
        cache: false
    });
}
</script>