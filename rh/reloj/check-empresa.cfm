<cfif Not IsDefined('session.sitio.Ecodigo') or Len(session.sitio.Ecodigo) Is 0 or session.sitio.Ecodigo Is 0>

	<cf_template>
		<cf_templatearea name="title">
			Recursos Humanos
		</cf_templatearea>
		
		<cf_templatearea name="body"><br>
		<br>
			<center style="font-size:24px;font-family:Georgia, 'Times New Roman', Times, serif ">
			El acceso a esta secci&oacute;n <br>
			debe hacerse por dominio <br><strong>espec&iacute;fico</strong> de empresa.<br>
<br>
Consulte con el administrador del sistema<br>
sobre la manera de activar este reloj.
			</center><br>
		<br>

		</cf_templatearea>
	</cf_template>
	<cfabort>

</cfif>