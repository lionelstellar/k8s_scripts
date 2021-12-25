## Cronjob
一个 CronJob 对象就像crontab（cron 表）文件的一行。它按照给定的计划定期运行作业，以Cron格式编写。  
例如，CronJob 清单每分钟打印一次当前时间和一条 hello 消息：
```
    apiVersion: batch/v1
    kind: CronJob
    metadata:
    name: hello
    spec:
    schedule: "*/1 * * * *"
    jobTemplate:
        spec:
        template:
            spec:
            containers:
            - name: hello
                image: busybox
                imagePullPolicy: IfNotPresent
                command:
                - /bin/sh
                - -c
                - date; echo Hello from the Kubernetes cluster
            restartPolicy: OnFailure
```
定时说明：
```
    # ┌───────────── minute (0 - 59)
    # │ ┌───────────── hour (0 - 23)
    # │ │ ┌───────────── day of the month (1 - 31)
    # │ │ │ ┌───────────── month (1 - 12)
    # │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday;
    # │ │ │ │ │                                   7 is also Sunday on some systems)
    # │ │ │ │ │
    # │ │ │ │ │
    # * * * * *
```

备注：
* 如果startingDeadlineSeconds设置为一个较大的值或未设置（默认值）并且如果concurrencyPolicy设置为Allow，则作业将始终至少运行一次。
* 如果startingDeadlineSeconds设置为小于 10 秒的值，则可能无法安排 CronJob。这是因为 CronJob 控制器每 10 秒检查一次。


