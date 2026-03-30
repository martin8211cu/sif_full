<div class="ayuda">
	<cfif Session.Compras.Configuracion.Pantalla EQ "0">
	  <strong>Configuraci&oacute;n Inicial de Tipos de Solicitud:</strong><br>
	<br>
		La presente es una lista con los tipos de solicitud existentes en el sistema, usted puede modificar uno de ellos o crear uno nuevo, para modificar u observar la informaci&oacute;n de uno de ellos presione el bot&oacute;n izquierdo del rat&oacute;n sobre la l&iacute;nea correspondiente al tipo de solicitud que desea. Para crear uno nuevo presione el bot&oacute;n &quot;Nuevo&quot;, que se encuentra en la parte inferior de la lista. <br>
		<br>
	<cfelseif Session.Compras.Configuracion.Pantalla EQ "1">
		<strong>Paso 1:</strong><br>
		<font color=black><span lang=ES-CR 
style="COLOR: windowtext; mso-ansi-language: ES-CR">Tipos de Solicitud: Permite agrupar los conceptos de compra de la organizaci&oacute;n y a su vez identificar la naturaleza de la solicitud en tres conceptos b&aacute;sicos, inventarios, activos y servicios.<o:p></o:p></span></font><br><br>
	<cfelseif Session.Compras.Configuracion.Pantalla EQ "2">
		<strong>Paso 2:</strong><br>
		<font color=black><span lang=ES-CR 
style="COLOR: windowtext; mso-ansi-language: ES-CR">Permite asociar de forma simple el <b style="mso-bidi-font-weight: normal"><span 
style="FONT-WEIGHT: bold; mso-bidi-font-weight: normal">&ldquo;qu&eacute;&rdquo;</span></b> bienes y/o servicios se pueden solicitar en la organizaci&oacute;n al <b 
style="mso-bidi-font-weight: normal"><span 
style="FONT-WEIGHT: bold; mso-bidi-font-weight: normal">&ldquo;quien&rdquo;</span></b> puede solicitarlo, el sistema ofrece una asociaci&oacute;n entre tipos de solicitud y centros funcionales, donde definimos al sistema qu&eacute; se va a comprar y quienes pueden solicitar dichas compras.<o:p></o:p></span></font><br><br>
	<cfelseif Session.Compras.Configuracion.Pantalla EQ "3">
		<p><strong>Paso 3:</strong><br>
	    <font color=black><span lang=ES-CR style="COLOR: windowtext; mso-ansi-language: ES-CR">Si la organizaci&oacute;n necesita definir que puede solicitar cada una de las &aacute;reas, el sistema provee una estructura de especializaci&oacute;n por tipo de solicitud y centro funcional, en esta estructura se agregan todas las reglas. Esta especializaci&oacute;n puede realizarse con base en:</span></font>
			<ul>
			<li>
			<span style="FONT: 7pt 'Times New Roman'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span>clasificaci&oacute;n de los art&iacute;culos (al &uacute;ltimo nivel),</span>
			</li>
			<li>
			<span style="FONT: 7pt 'Times New Roman'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span>activos fijos por categor&iacute;a y clase,</span>
			</li>
			<li>
			<span style="FONT: 7pt 'Times New Roman'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span>clasificaci&oacute;n de servicios (al &uacute;ltimo nivel).<o:p></o:p><o:p>&nbsp;</span>
			</li>
			</ul>
    </p>
	</cfif>
</div>
