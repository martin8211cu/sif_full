<cfparam name="url.FMEmailid" default="">
<cfquery datasource="#session.dsn#" name="data">
	select me.*, fm.LFnumero
	from  ISBfacturaMediosEmail me
		left join ISBfacturaMedios fm
			on me.LFlote = fm.LFlote
	where FMEmailid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.FMEmailid#" null="#Len(url.FMEmailid) Is 0#">
</cfquery>
<cfquery datasource="#session.dsn#" name="archivo">
	select
		FMEarchivo, FMEtotal, FMEerrores, FMEignorados,
		FMEinicio, FMEfin, FMEnombre, FMEobs, datalength (FMEcontent) as contentLength
	from  ISBfacturaMediosArchivo
	where FMEmailid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.FMEmailid#" null="#Len(url.FMEmailid) Is 0#">
</cfquery>

<cfoutput>

	<cfif data.FMEestado is 'P'>
		<cfhtmlhead text='<meta http-equiv="refresh" content="15" />'>
	</cfif>

<script type="text/javascript">
<!--

	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBfacturaMediosEmail - ISBfacturaMediosEmail 
				// Columna: FMEinout Dirección char(3)
				if (formulario.FMEinout.value == "") {
					error_msg += "\n - Dirección no puede quedar en blanco.";
					error_input = formulario.FMEinout;
				}
			
				// Columna: FMEfrom Email from varchar(60)
				if (formulario.FMEfrom.value == "") {
					error_msg += "\n - Email from no puede quedar en blanco.";
					error_input = formulario.FMEfrom;
				}
			
				// Columna: FMEto Email to varchar(60)
				if (formulario.FMEto.value == "") {
					error_msg += "\n - Email to no puede quedar en blanco.";
					error_input = formulario.FMEto;
				}
			
				// Columna: FMEsubject Email subject varchar(60)
				if (formulario.FMEsubject.value == "") {
					error_msg += "\n - Email subject no puede quedar en blanco.";
					error_input = formulario.FMEsubject;
				}
			
				// Columna: FMErecibido Fecha recibido datetime
				if (formulario.FMErecibido.value == "") {
					error_msg += "\n - Fecha recibido no puede quedar en blanco.";
					error_input = formulario.FMErecibido;
				}
			
				// Columna: FMEestado Estado (N/P/T) char(1)
				if (formulario.FMEestado.value == "") {
					error_msg += "\n - Estado (N/P/T) no puede quedar en blanco.";
					error_input = formulario.FMEestado;
				}
						
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		return true;
	}
	function funcNuevo(){
		location.href = 'ISBfacturaMediosEmail-edit.cfm';
		return false;
	}
//-->
</script>



<table width="950" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="80" align="right" valign="top"><strong>Asunto:</strong></td>
    <td width="3" valign="top">&nbsp;</td>
    <td width="358" valign="top"><strong>#HTMLEditFormat(data.FMEsubject)#</strong></td>
    <td width="106" align="right" valign="top"><strong>Núm Lote:</strong></td>
    <td width="4" valign="top">&nbsp;</td>
    <td width="375" valign="top"><cfif Len(data.LFnumero)>#HTMLEditFormat(data.LFnumero)#<cfelse>N.D.</cfif></td>
  </tr>
  
  <tr>
    <td align="right" valign="top"><strong>De:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top">#HTMLEditFormat(data.FMEfrom)#</td>
    <td align="right" valign="top"><strong>Estado:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top"><cfif data.FMEestado is 'N'>
      Nuevo
      <cfelseif data.FMEestado is 'P'>
      Procesando
      <cfelseif data.FMEestado is 'T'>
      Terminado
      <cfelse>
      #data.FMEestado#
    </cfif></td>
  </tr>
  <tr>
    <td align="right" valign="top"><strong>Fecha:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top">#DateFormat(data.FMErecibido,'dd/mm/yyyy')# #TimeFormat(data.FMErecibido,'HH:mm:ss')#</td>
    <td align="right" valign="top"><strong>Inicio proceso: </strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top">#DateFormat(data.FMEinicio,'dd/mm/yyyy')# #TimeFormat(data.FMEinicio,'HH:mm:ss')#</td>
  </tr>
  <tr>
    <td align="right" valign="top"><strong>Para:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top">#HTMLEditFormat(data.FMEto)#</td>
    <td align="right" valign="top"><strong>Fin proceso:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top">#DateFormat(data.FMEfin,'dd/mm/yyyy')# #TimeFormat(data.FMEfin,'HH:mm:ss')#
	<cfif Len(data.FMEinicio) And Len(data.FMEfin)>
		<cfset elapsed = DateDiff('s', data.FMEinicio, data.FMEfin) / 86400>
		(<cfif elapsed GT 1>
		#NumberFormat(Int(elapsed))# d
		</cfif>
		<cfif elapsed GE 1/24>
		#TimeFormat(elapsed, 'HH:mm:ss')# 
		<cfelse>
		#TimeFormat(elapsed, 'mm:ss')# 
		</cfif>transcurridos )
	</cfif>
	</td>
  </tr>
  
  <tr>
    <td colspan="6" align="left" valign="top">&nbsp;</td>
    </tr>
  
  <tr>
    <td colspan="3" valign="top">
	<cfif Len(data.FMEbody)><div style="border:1px solid black;padding:10px;width:95%;height:200px;overflow:scroll;">
		<strong>Texto del mensaje:<br /></strong> <cfset bodyStart = FindNoCase('<body', data.FMEbody)>
		<cfset bodyEnd = FindNoCase('</body>', data.FMEbody)>
		<cfif bodyStart And bodyEnd and bodyStart LT bodyEnd>
			<cfset bodyStart = FindNoCase('>', data.FMEbody, bodyStart)>
			# Mid(data.FMEbody, bodyStart+1, bodyEnd - bodyStart -1 )#
		<cfelse>
			#HTMLEditFormat(data.FMEbody)#
		</cfif>
	<cfelse>-mensaje vacío-</cfif></div></td>
	<td colspan="3" valign="top"><cfif archivo.RecordCount>
	  <table width="485" border="0" cellspacing="0" cellpadding="2">
	    <tr>
	      <td colspan="3" rowspan="2" style="border:1px solid" valign="bottom"><strong>Archivos adjuntos </strong></td>
		  <cfif Trim(data.FMEinout) is 'in'>
          <td colspan="3" align="center" valign="bottom" style="border-width:1 1 0 0;border-style:solid"><strong>Líneas</strong></td>
		  </cfif>
          <td rowspan="2" align="right"  valign="bottom"style="border-width:1 1 1 0;border-style:solid"><strong>Descargar</strong></td>
	    </tr>
	    <tr>
		  <cfif Trim(data.FMEinout) is 'in'>
	      <td align="right" valign="bottom" style="border-width:1 1 1 0;border-style:solid"><strong>&nbsp;Total&nbsp;</strong></td>
          <td align="right" valign="bottom" style="border-width:1 1 1 0;border-style:solid"><strong>&nbsp;Ignoradas&nbsp;</strong></td>
          <td align="right" valign="bottom" style="border-width:1 1 1 0;border-style:solid"><strong>&nbsp;Errores&nbsp;</strong></td>
		  </cfif>
          </tr><cfloop query="archivo">

<cfset lista = ListGetAt('listaPar,listaNon', CurrentRow mod 2 + 1)>
  <tr class="#lista#" onmouseover="this.className='#lista#Sel';" onmouseout="this.className='#lista#';" style="cursor:default">
              <td width="11" style="border-width:0 0 0 1;border-style:solid">&nbsp;</td>
          <td width="10" align="right" style="border-width:0 0 0 0;border-style:solid">
		  <cfif Len(archivo.FMEobs)>
		  	<cfset alert_message = archivo.FMEobs>
		  <cfelseif archivo.FMEerrores>
		  	<cfset alert_message = 'El archivo contiene ' & archivo.FMEerrores & ' errores'>
		  <cfelseif Not Len(archivo.FMEfin)>
		  	<cfset alert_message = 'El archivo no se terminó de procesar'>
		  <cfelseif Not Len(archivo.FMEinicio)>
		  	<cfset alert_message = 'El archivo no se comenzó a procesar'>
		  <cfelse>
		  	<cfset alert_message = 'El archivo se procesó en ' & DateDiff('s', archivo.FMEinicio, archivo.FMEfin) & ' segundos'>
		  </cfif>
		  <div title="#HTMLEditFormat(archivo.FMEobs)#" style="cursor:pointer" onclick="alert(&quot;#HTMLEditFormat( JSStringFormat( alert_message ))#&quot;)" >
		  <cfif archivo.FMEerrores Or ( Len(archivo.FMEinicio) And Not Len(archivo.FMEfin))>
		  	<img src="/cfmx/asp/admin/politicas/global/rechazado.gif" width="13" height="12" />
		  <cfelseif (Not archivo.FMEerrores) And Len(archivo.FMEfin)>
		  	<img src="/cfmx/asp/admin/politicas/global/aceptado.gif" width="13" height="12" />
		  </cfif>
		  </div>		  </td>
          <td width="253" style="border-width:0 1 0 0;border-style:solid"><div style="width:100%;overflow:hidden;white-space:nowrap;cursor:pointer" onclick="alert(&quot;#HTMLEditFormat( JSStringFormat( alert_message ))#&quot;)" >
		  	<cfif ListLen(archivo.FMEnombre, ':') GT 1>&nbsp;&nbsp;&bull;</cfif>
		  #HTMLEditFormat(ListLast(archivo.FMEnombre, ':'))#</div></td>
		  <cfif Trim(data.FMEinout) is 'in'>
		  <td width="24" align="right" style="border-width:0 1 0 0;border-style:solid"><cfif archivo.FMEtotal>#NumberFormat(archivo.FMEtotal)#<cfelse>&nbsp;</cfif></td>
          <td width="24" align="right" style="border-width:0 1 0 0;border-style:solid"><cfif archivo.FMEignorados>#NumberFormat(archivo.FMEignorados)#<cfelse>&nbsp;</cfif></td>
          <td width="47" align="right" style="border-width:0 1 0 0;border-style:solid"><cfif archivo.FMEerrores>#NumberFormat(archivo.FMEerrores)#<cfelse>&nbsp;</cfif></td>
		  </cfif>
          <td width="96" align="right" style="border-width:0 1 0 0;border-style:solid">
            <cfif archivo.contentLength><a class="btnGuardar" href="ISBfacturaMediosArchivo-download.cfm?FMEarchivo=#archivo.FMEarchivo#">
			<cfif archivo.contentLength GE 104857600>
			#NumberFormat(archivo.contentLength/1048576, ',0')# MB
			<cfelseif archivo.contentLength GE 1048576>
			#NumberFormat(archivo.contentLength/1048576, ',0.0')# MB
			<cfelseif archivo.contentLength GE 102400>
			#NumberFormat(archivo.contentLength/1024, ',0')# KB
			<cfelse>
			#NumberFormat(archivo.contentLength/1024, ',0.0')# KB
			</cfif></a><cfelse>&nbsp;</cfif>		</td>
        </tr>
          </cfloop>
            <tr>
              <td colspan="7" style="border-width:1 0 0 0;border-style:solid">&nbsp;</td>
            </tr>
	    </table>
    </cfif></td>
	</tr>
  <tr>
    <td colspan="6"></td>
  </tr>
</table>
<form action="javascript:void(0)">
			<input type="button" name="Regresar" class="btnAnterior" value="Regresar" onclick="javascript:location.href='index.cfm?tab=#url.tab#';">     
  </form>
</cfoutput>

