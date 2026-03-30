Los componentes en este directorio serán invocados por 
UO cuando requiera invocar la lógica de una interfaz desde
o hacia saci.
El parámetro "origen" en los métodos remotos indicará si
la transacción se origina en saci, en cuyo caso deberá afectaral siic,
o si se origina en el siic, debiendo afectar a saci y notificar el
cumplimiento al siic
