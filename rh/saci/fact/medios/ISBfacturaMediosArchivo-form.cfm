<cfparam name="url.FMEarchivo" default="">
<cfquery datasource="#session.dsn#" name="data">
	select *,
		FMEprocesados + FMEignorados + FMEerrores as avance,
		datalength(FMEcontent) as contentLength, coalesce (FMEfin, FMEtimestamp, getdate()) as FMEfinNotNull
	from  ISBfacturaMediosArchivo where FMEarchivo =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.FMEarchivo#" null="#Len(url.FMEarchivo) Is 0#">
	</cfquery>

	<cfif Not Len(data.FMEfin)>
		<cfhtmlhead text='<meta http-equiv="refresh" content="15" />'>
	</cfif>
<cfoutput>

	<table width="673">
	<tr>
	  <td colspan="4" class="subTitulo">Archivo <cfif data.FMEtipoArchivo is 'D'>
	    enviado
	    <cfelseif data.FMEtipoArchivo is 'A'>
	    recibido de aplicados
	    <cfelseif data.FMEtipoArchivo is 'I'>
	    recibido de inconsistencias
	    <cfelseif data.FMEtipoArchivo is '-'>
	    de tipo no especificado
	    <cfelseif data.FMEtipoArchivo is 'L'>
	    recibido de liquidaci&oacute;n
	    <cfelse> de tipo
	    # HTMLEditFormat( data.FMEtipoArchivo )#
	    </cfif>      </td>
	  </tr>
	
		<tr><td width="27" valign="top">&nbsp;</td>
		  <td width="172" valign="top">Modo de ingreso</td>
		  <td colspan="2" valign="top">
		<cfif Len(data.FMEmailid)>
			Por correo
		<cfelse>
			Carga manual
		</cfif>		</td>
	    </tr>
		
		<tr><td valign="top">&nbsp;</td>
		  <td valign="top">Nombre de archivo </td>
		  <td colspan="2" valign="top">
		
	    #HTMLEditFormat(data.FMEnombre)#		</td>
	    </tr>
		

<cfif Len(data.contentLength) and data.contentLength NEQ 0>
		<tr>
		  <td valign="top">&nbsp;</td>
		  <td valign="top">Tamaño</td>
		  <td colspan="2" valign="top">
            <a class="btnGuardar" href="ISBfacturaMediosArchivo-download.cfm?FMEarchivo=#data.FMEarchivo#">
			<cfif data.contentLength GE 104857600>
			#NumberFormat(data.contentLength/1048576, ',0')# MB
			<cfelseif data.contentLength GE 1048576>
			#NumberFormat(data.contentLength/1048576, ',0.0')# MB
			<cfelseif data.contentLength GE 102400>
			#NumberFormat(data.contentLength/1024, ',0')# KB
			<cfelse>
			#NumberFormat(data.contentLength/1024, ',0.0')# KB
			</cfif></a>		</td>
      </tr></cfif>
		

		<tr><td valign="top">&nbsp;</td>
		  <td valign="top">Inicio proceso </td>
		  <td colspan="2" valign="top">
		#DateFormat(data.FMEinicio,'dd/mm/yyyy')#
		#TimeFormat(data.FMEinicio,'HH:mm:ss')#		</td>
	    </tr>
		
		<tr><td valign="top">&nbsp;</td>
		  <td valign="top">Fin proceso </td>
		  <td colspan="2" valign="top">
		#DateFormat(data.FMEfin,'dd/mm/yyyy')#
		#TimeFormat(data.FMEfin,'HH:mm:ss')#		</td>
	    </tr>
		<cfif Len(data.FMEinicio)>
			<tr><td valign="top">&nbsp;</td>
			  <td valign="top">Duración </td>
			  <td colspan="2" valign="top">
			<cfset elapsed = DateDiff('s', data.FMEinicio, data.FMEfinNotNull)>
			<cfif elapsed LT 1>
				&lt; 00:00:01
			<cfelse>
				<cfif elapsed GT 86400>
				#NumberFormat(Int(elapsed / 86400))# d
				</cfif>
				#TimeFormat(elapsed / 86400, 'H:mm:ss')#</cfif></td>
		    </tr>
		<cfif Len(data.avance) and (data.avance NEQ 0) and (elapsed GT 0)>
			<tr>
			  <td valign="top">&nbsp;</td>
			  <td valign="top">Rendimiento</td>
			  <td colspan="2" valign="top">#NumberFormat(elapsed*1000 / data.avance, ',0.00')# milisegundos por registro</td>
	      </tr>
		</cfif>
		</cfif>
		<cfif Len(data.FMEobs)>
		<tr><td colspan="2" valign="top">Observaciones		</td><td colspan="2" valign="top">
		
		  #HTMLEditFormat(data.FMEobs)#
		
		</td>
		  </tr>
		</cfif>
		<tr>
          <td colspan="4" valign="top" class="subTitulo">Registros en el archivo </td>
		  </tr>
		<tr>
          <td>&nbsp;</td>
		  <td>Total</td>
		  <td width="124">#NumberFormat(data.FMEtotal)#</td>
		  <td width="330"><div style="width:320px;background-color:white;border:1px solid">&nbsp;</div></td>
		</tr>
		  <cfif  Len(data.avance) and data.avance NEQ 0>
		<tr>
          <td>&nbsp;</td>
		  <td>Avance</td>
		  <td>#NumberFormat(data.avance)#</td>
		  <td nowrap="nowrap" style="white-space:nowrap"><cfif Len(data.FMEtotal) and data.FMEtotal NEQ 0 > 
		  <cfset fraccion_avance = data.avance/data.FMEtotal>
		  <div style="width:#Int(320.*fraccion_avance)#px;background-color:skyblue;border:1px solid">
		  #NumberFormat(fraccion_avance*100.0, '0.0')#%</div>
		  </cfif>
		  </td>
		</tr><cfif Len(data.FMEtotal) and data.FMEtotal NEQ 0 and Len(data.FMEinicio) and fraccion_avance NEQ 0 and fraccion_avance LT 1>
		<tr>
          <td>&nbsp;</td>
		  <td>Tiempo restante</td>
		  <td nowrap="nowrap" style="white-space:nowrap">
		  <cfset tiempo_restante = elapsed / fraccion_avance * (1-fraccion_avance)>
		  <cfif tiempo_restante LT 1>
				&lt; 00:00:01
			<cfelse>
				<cfif tiempo_restante GT 86400>
				#NumberFormat(Int(tiempo_restante / 86400))# d
				</cfif>
				#TimeFormat(tiempo_restante / 86400, 'H:mm:ss')#</cfif>
		  
		  </td>
		  <td>&nbsp;</td>
		</tr></cfif></cfif>
		<tr>
          <td>&nbsp;</td>
		  <td>Aceptados</td>
		  <td>#NumberFormat(data.FMEprocesados)#</td>
		  <td>&nbsp;</td>
		</tr>
		<tr>
          <td>&nbsp;</td>
		  <td>Ignorados</td>
		  <td>#NumberFormat(data.FMEignorados)#</td>
		  <td>&nbsp;</td>
		</tr>
		<tr>
          <td>&nbsp;</td>
		  <td>Errores</td>
		  <td>#NumberFormat(data.FMEerrores)#</td>
		  <td>&nbsp;</td>
		</tr>
		
        <tr>
          <td colspan="4">&nbsp;</td>
        </tr>
      <tr><td colspan="4" class="formButtons">
<form action="javascript:void(0)" name="form1" id="form1">
	  <input type="button" name="Regresar" class="btnAnterior" value="Regresar" onclick="javascript:location.href='index.cfm?tab=liq';">     
</form>

	</td></tr>
	</table>

</cfoutput>

