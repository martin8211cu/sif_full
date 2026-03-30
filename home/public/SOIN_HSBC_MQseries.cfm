<Cfscript>
...
// Create a "manager" object    
manager   =   
createObject("JAVA","com.ibm.mq.MQQueueManager").init("MQDEV.QUEUE.MAN");
....
</CFSCRIPT>