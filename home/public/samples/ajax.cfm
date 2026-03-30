<cf_importlibs>
<div class="post-body entry-content">
<p>    </p><h3>Ajax en jQuery la explicación que faltaba, con todos los ejemplos</h3>
<div class="separator" style="clear: both; text-align: left;">
<a href="http://4.bp.blogspot.com/-WwoWFVadLO8/UebDFwLXxMI/AAAAAAAACec/YQi6oVqgqXk/s1600/jquery-log.png" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img border="0" src="http://4.bp.blogspot.com/-WwoWFVadLO8/UebDFwLXxMI/AAAAAAAACec/YQi6oVqgqXk/s320/jquery-log.png"></a></div>
<p>
Vamos a ver las mejores maneras de utilizar <strong>AJAX</strong> junto a <strong>jQuery</strong></p>
<p>
En primer lugar expliquemos que AJAX es una tecnología bastante madura
por la cual los navegadores pueden realizar peticiones web sin recargar
completamente la página. La librería jQuery tiene una serie de funciones
muy convenientes con las cuales podremos simplificar el uso de AJAX para todos los 
navegadores soportados.</p>

<p>
Hay varias funciones que implican el uso de AJAX en jQuery a continuación te presentamos las más comunes y 
una breve descripción de su caso de uso más común. Es importante tener presente este resumen porque la al 
haber tantas funciones uno no sabe exactamente cuál usar, esta lista los ayudará con esa decisión.
</p>
<ul>
<li><a href="#post_get">jQuery.get</a>: hace una petición HTTP GET debería ser uno de los usos más comunes, sobre todo cuando no deseas mandar muchos datos al servidor o para acciones que no modifican el estado del server.</li>
<li><a href="#post_post">jQuery.post</a>: hace una petición HTTP POST deberías usarla cuando queres enviar muchos datos al servidor o cuando deseas modificar el estado del server.</li>
<li><a href="#post_getJSON">jQuery.getJSON</a>: Si quien responde envia JSON, este es un buen método para simplificar la llamada porque te entregará el objeto listo para usar.</li>
<li><a href="#post_load">jQuery.load</a>: muy popular entre los usuarios de jQuery, esta petición pone el resultado directamente en el elemento desde que se llamó.</li>
<li><a href="#post_ajax">jQuery.ajax o $.ajax</a>: es la función más generica o de más bajo nivel con esta podrás hacer cualquiera de los llamados AJAX que se logran con las otras.</li>
</ul>

<h4 id="post_get">
jQuery.get e introducción a llamadas asincrónicas</h4>
<p>
La forma más sencilla de la función es <code>$.get(url)</code> 
dónde <code>url</code> es el recurso que queremos solicitar. Al ejecutar ese código
simplemente le diremos a nuestro navegador que abra una petición a esa url y que no haga
nada con el resultado. No estaríamos haciendo nada en la página, pero tal vez nos interese 
para notificar al server de algo (por ejemplo hacerlo cada cierto tiempo para no que no se 
desloguee un usuario).
</p>
<p>
La forma más común de esta función es en realidad <code>$.get(url, function(resultado) {})</code> 
con esta forma estamos pasando una función que se ejecutará con el resultado cuando la petición termine.
Es importante entendender que las peticiones en AJAX son por defecto <strong>asincrónicas</strong>, esto 
significa que el javascript continuará la ejecución de las siguientes instrucciones que sigan a una petición
y en otro hilo de ejecución comenzará a realizar la entrada y salida necesaria para la petición. <strong>¿No entendiste nada de asincrónico y entrada/salida?</strong></p>
<p>&nbsp;</p>
<h4 id="post_post">
  jQuery.post haciendo una petición POST y su diferenciación con .get</h4>

<p>
Con este método haremos una petición HTTP de tipo POST,
usualmente útilizadas para realizar una acción que cambie el
estado del servidor. ¿A qué me refiero? Cuando vos te traes una
lista de usuarios generalmente no estás modificando para nada el
estado del servidor. Simplemente estás solicitando un listado y no
modificas ninguno de sus datos. El servidor seguramente hará una
query sql de tipo <code>SELECT ... </code> y tu petición no
causará ninguna modificación en el estado del servidor. Ese tipo
de peticiones suelen (y deberían hacerse) con peticiones
de <strong>tipo get</strong> (utilizando la función <code>$.get</code>). 
Contrariamente si uno actualiza un nombre de usuario, o borra un usuario estaría 
causando un cambio en el servidor por lo que lo correcto es usar una petición
POST con la función <code>$.post</code>. Otra razón para utilizar una petición
POST es si la cantidad de datos a enviar al servidor es muy grande (las peticiones GET envian
los datos como parte de la URL y algunos servidores web limitan el tamaño que una URL puede tener).
</p>
<p>
Veamos el mismo ejemplo anterior pero ahora utlizando peticiones POST:</p>
<div class="exampleContainer"><button class="buttonRun" onclick="ejecutarPost()">Ejecutar ejemplo</button><pre class="ejemplo  examplejavascript">
    $.post('ejemplo.cfc?method=getEmpleadosTable', function(data) {
        console.log('Termino de cargar la primer petición');
     });
   </pre><textarea class="codeEdit" style="display: none; height: 180px;"></textarea><div class="outputJavascript" id="js-output1" style="display: block;">Comienza ejecución
Última línea del programa
Termino de cargar la segunda petición
Termino de cargar la primer petición
</div></div>
<p>
Como verán cambiar la función get por post no cambia el caracter
asincrónico del programa, ya que como dijimos todas las llamadas
AJAX son por defecto asincrónicas.</p>

<p>
Lo siguiente es mostrar un ejemplo en dónde enviamos datos al servidor.</p>
<p>
Como dijimos en el caso de <code>$.get</code> los datos se enviarán como
parte de la URL (usualmente a estos datos se los llama query string y toman la forma de 
<code>?clave=valor&amp;clave2=valor2</code>) en cambio en el caso de POST los datos
seran parte del cuerpo de la petición. Por dar el ejemplo más común de un lenguaje servidor:
en PHP podrás acceder a los datos enviados por AJAX con: <code>$_GET["clave"]</code>, <code>$_POST["clave"]</code> o si 
queres revisar los dos el conveniente <code>$_REQUEST["clave"]</code>. 
Visto esto veamos dos ejemplos en los que enviamos datos al servidor, la forma es igual para
get y post:
</p>
<pre class="ejemplo"><button class="buttonRun" onclick="ejecutarPost1()">Ejecutar ejemplo</button>
	$.post("ejemplo.cfc?method=getEmpleadosTable", {DEnombre: "Fre"}, function(respuesta) {
        console.log("La respuesta es:", respuesta)
     });
    
</pre>
<h4 id="post_getJSON">
  Trabajando con JSON getJSON</h4>
<p>
Suele ser bastante común que las páginas planeadas para el uso de AJAX utilicen JSON
como lenguaje de intercambio con el servidor. Esto permite que el servidor responda
de manera liviana sin toda la sobrecarga que implica el uso de HTML, y con la ventaja de que
los datos recibidos son fácilmente parseables por el navegador. La función <code>$.getJSON</code>
realiza (a igual que <code>$.get</code>) una petición GET, con la diferencia de que esperará 
como respuesta del servidor JSON bien formado.
</p>
<p>
Veamos primero como podría ser esta vez el archivo <code>test-json.php</code></p>
<pre class="ejemplo">&lt;?php
$datos = array("mensaje" =&gt; "Hola soy json", "error" =&gt; false);
echo json_encode($datos);
</pre>

<p>
Veamos ahora el programa que podría pedir por estos datos:</p>
<button class="buttonRun" onclick="ejecutarPost2()">Traer JSON</button>
<pre class="ejemplo">

$.post("ejemplo.cfc?method=getEmpleadosJSON", {DEnombre: &quot;Fred&quot;}, function(respuesta) {
        console.log("La respuesta es:", respuesta)
      });

</pre>
<p>
Si todo fue bien en el callback recibirás un objeto javascript construído a partir
del json enviado por el servidor.</p>

<p>
<strong>NOTA SOBRE ERRORES:</strong> no es poco común ver errores de
CrossOrigin entre los que empiezan a utilizar AJAX. Estos errores se
deben a que debido a políticas de seguridad los navegadores sólo
permiten hacer peticiones al mismo dominio desde dónde cargo la
página. Es decir uno no podría hacer una petición AJAX a google.com si
el navegador se encuentra en la página de Codigo Fuente. Este problema
puede solucionarse utilizando otras técnicas como JSONP que implica el
uso de tags <code>script</code>, pero esta técnica es algo más
compleja y la veremos en algún otro artículo.</p>
<h4 id="post_ajax">
  jQuery.ajax la función bajo nivel</h4>
<p>
Esta es la función de más bajo nivel que posee jQuery utilizandola podremos controlar
todos los aspectos importantes de la petición AJAX que estemos haciendo.</p>
<p>
Veamos un ejemplo: </p>
<button class="buttonRun" onclick="ejecutarPost3()">Traer AJAX</button>
<pre class="ejemplo">$.ajax("/test.php", {
   "type": "post",   // usualmente post o get
   "success": function(result) {
     console.log("Llego el contenido y no hubo error", result);
   },
   "error": function(result) {
     console.error("Este callback maneja los errores", result);
   },
   "complete":function(result) {
    alert("completo")
   },
   "beforeSend":function(result) {
    alert("beforeSend")
   },
   "data": {DEnombre: &quot;Fred&quot;},
   "async": true,
});
</pre>
<p>
Es interesante el último de los parametros porque permite apagar el
comportamiento asincrónico de la petición lo que causaría que antes de
ejecutar la siguiente instrucción javascript espere a que se termine
de ejecutar la petición.
</p>
<p></p>
<div style="clear: both;"></div>
</div>

<div class="table" id="table_10_6">

    <table border="1">
<thead>
<tr>
  <th>Opción</th>
  <th>Descripción</th>
</tr>
</thead>
<tbody>
<tr>
  <td><code>async</code></td>
  <td>Indica si la petición es asíncrona. Su valor por defecto es <code>true</code>, el habitual para las peticiones AJAX</td>
</tr>
<tr>
  <td><code>beforeSend</code></td>
  <td>Permite indicar una función que modifique el objeto <code>XMLHttpRequest</code> antes de realizar la petición. El propio objeto <code>XMLHttpRequest</code> se pasa como único argumento de la función</td>
</tr>
<tr>
  <td><code>complete</code></td>
  <td>Permite establecer la función que se ejecuta cuando una petición se ha completado (y después de ejecutar, si se han establecido, las funciones de <code>success</code> o <code>error</code>). La función recibe el objeto <code>XMLHttpRequest</code> como primer parámetro y el resultado de la petición como segundo argumento</td>
</tr>
<tr>
  <td><code>contentType</code></td>
  <td>Indica el valor de la cabecera <code>Content-Type</code> utilizada para realizar la petición. Su valor por defecto es <code>application/x-www-form-urlencoded</code></td>
</tr>
<tr>
  <td><code>data</code></td>
  <td>Información que se incluye en la petición. Se utiliza para enviar parámetros al servidor. Si es una cadena de texto, se envía tal cual, por lo que su formato debería ser <code>parametro1=valor1&amp;parametro2=valor2</code>. También se puede indicar un array asociativo de pares clave/valor que se convierten automáticamente en una cadena tipo <em>query string</em></td>
</tr>
<tr>
  <td><code>dataType</code></td>
  <td>El tipo de dato que se espera como respuesta. Si no se indica ningún valor, jQuery lo deduce a partir de las cabeceras de la respuesta. Los posibles valores son: <code>xml</code> (se devuelve un documento XML correspondiente al valor <code>responseXML</code>), <code>html</code> (devuelve directamente la respuesta del servidor mediante el valor <code>responseText</code>), <code>script</code> (se evalúa la respuesta como si fuera JavaScript y se devuelve el resultado) y <code>json</code> (se evalúa la respuesta como si fuera JSON y se devuelve el objeto JavaScript generado)</td>
</tr>
<tr>
  <td><code>error</code></td>
  <td>Indica la función que se ejecuta cuando se produce un error durante la petición. Esta función recibe el objeto <code>XMLHttpRequest</code> como primer parámetro, una cadena de texto indicando el error como segundo parámetro y un objeto con la excepción producida como tercer parámetro</td>
</tr>
<tr>
  <td><code>ifModified</code></td>
  <td>Permite considerar como correcta la petición solamente si la respuesta recibida es diferente de la anterior respuesta. Por defecto su valor es <code>false</code></td>
</tr>
<tr>
  <td><code>processData</code></td>
  <td>Indica si se transforman los datos de la opción <code>data</code> para convertirlos en una cadena de texto. Si se indica un valor de <code>false</code>, no se realiza esta transformación automática</td>
</tr>
<tr>
  <td><code>success</code></td>
  <td>Permite establecer la función que se ejecuta cuando una petición se ha completado de forma correcta. La función recibe como primer parámetro los datos recibidos del servidor, previamente formateados según se especifique en la opción <code>dataType</code></td>
</tr>
<tr>
  <td><code>timeout</code></td>
  <td>Indica el tiempo máximo, en milisegundos, que la petición espera la respuesta del servidor antes de anular la petición</td>
</tr>
<tr>
  <td><code>type</code></td>
  <td>El tipo de petición que se realiza. Su valor por defecto es <code>GET</code>, aunque también se puede utilizar el método <code>POST</code></td>
</tr>
<tr>
  <td><code>url</code></td>
  <td>La URL del servidor a la que se realiza la petición</td>
</tr>
</tbody>
</table>
</div>


<script>
function ejecutarPost(){
	$.post('ejemplo.cfc?method=getEmpleadosTable', function(data) {
        console.log('Termino de cargar la primer petición');
     });
}
function ejecutarPost1(){
	$.post("ejemplo.cfc?method=getEmpleadosTable", {DEnombre: "Fre"}, function(respuesta) {
        console.log("La respuesta es:", respuesta)
      });
}
function ejecutarPost2(){
	$.post("ejemplo.cfc?method=getEmpleadosJSON", {DEnombre: "Fre"}, function(respuesta) {      
	console.log($.parseJSON(respuesta)["DATA"]);
		$.each($.parseJSON(respuesta)["DATA"], function(idx, obj) {
			console.log(obj[2]+" "+obj[3]+" "+obj[4]);
		});
	  });
}

function ejecutarPost3(){
$.ajax("ejemplo.cfc?method=getEmpleadosTable", {
   "type": "post",   // usualmente post o get
   "success": function(result) {
	   alert("Llego el contenido y no hubo error");
     console.log("Llego el contenido y no hubo error", result);
   },
   "error": function(result) {
	    alert("Este callback maneja los errores");
     console.error("Este callback maneja los errores", result);
   },
      "complete":function(result) {
    alert("completo")
   },
   "beforeSend":function(result) {
    alert("beforeSend")
   },
   "data": {DEnombre: "Fre"},
   "async": true,
});
}
</script>