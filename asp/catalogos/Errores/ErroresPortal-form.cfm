<cfset modo = "ALTA">
<cfset CERRref = "">
<cfif not isdefined('form.CERRcod') and isdefined('url.CERRcod')>
	<cfset form.CERRcod = url.CERRcod>
</cfif>
<cfif isdefined("form.CERRcod") and len(trim(form.CERRcod))>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="sifcontrol">
		 select  CERRcod, CERRmsg, CERRdes , CERRcor, CERRref
			from CodigoError
		where CERRcod = #form.CERRcod# 
	</cfquery>
	<cfset CERRref = #data.CERRref#>
<cfelse>
	<cfquery name="data" datasource="sifcontrol">
		 select  max(CERRcod)+1 as CERRcod
		  from CodigoError
	</cfquery>
</cfif>

<form style="margin:0;" name="form1" action="ErroresPortal-sql.cfm" method="post">
<cfoutput>
	<!---Codigo--->
	<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0" >
		<tr>
			<td align="left" valign="top">Código: 
				<input type="text" name="CERRcod" size="8" maxlength="15" value="<cfoutput>#data.CERRcod#</cfoutput>" onfocus="this.select();" readonly>
			</td>
		</tr>
	<!---Error--->	
		<tr>
			<td align="left" valign="top">Error: </td>
		</tr>
		<tr>
			<td nowrap>
			<textarea name="CERRmsg" rows="3"  style="font-family:sans-serif; width:100%;" onfocus="this.select();"><cfif modo neq 'ALTA'>#trim(data.CERRmsg)#</cfif></textarea>
			</td>
		</tr>
	<!---Referencia--->	
		<tr>
			<td align="left" valign="top">Referencia: </td>
		</tr>
		<tr>
			<td nowrap>
				<cfoutput>	
				<cf_conlis title="Lista de Errores del Portal"
					campos = "Refer, Error" 
					desplegables = "S,S" 
					modificables = "S,N" 
					size = "15,34"
					asignar="Refer, Error"
					asignarformatos="I,S"
					tabla="CodigoError"
					columnas="CERRcod Refer, CERRmsg Error"
					filtro="CERRcod <> #data.CERRcod# and CERRref is null order by CERRcod "
					desplegar=" Refer, Error "
					etiquetas=" Codigo, Error"
					formatos="I,S"
					align="left,left"
					showEmptyListMsg="true"
					EmptyListMsg=""
					form="form1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="CERRcod, CERRmsg "
					index="1"
					conexion="sifcontrol"		
					traerInicial="#CERRref  NEQ ''#"	
					traerFiltro="CERRcod=#CERRref#"
					funcion="funOcultar"
					funcionValorEnBlanco ="funMostrar"
				/>
			</cfoutput>
			</td>
		</tr>
		
	<!---Descripción--->	
		<tr><td align="left" valign="top" id="CERRdesLabel">
			Descripción:
			</td>
		</tr>
		<tr>
			<td nowrap>
			  <textarea name="CERRdes" rows="5" style="font-family:sans-serif; width:100%; display:block" onfocus="this.select();"><cfif modo neq 'ALTA'><cfoutput>#data.CERRdes#</cfoutput></cfif></textarea>
			</td>
		</tr>
	<!---Solución--->	
		<tr>
			<td align="left" valign="top" id="CERRcorLabel">Solución: </td>
		</tr>
		<tr>
			<td nowrap>
			  <textarea name="CERRcor" rows="5" style="font-family:sans-serif; width:100%; display:block:" onfocus="this.select();"><cfif modo neq 'ALTA'><cfoutput>#data.CERRcor#</cfoutput></cfif></textarea>
			</td>
		</tr>
<cfif modo neq 'ALTA'>
	<cfquery name="dataSrc" datasource="sifcontrol">
		 select  CERRSsrc
			from CodigoErrorSrc
		where CERRcod = #form.CERRcod# 
	</cfquery>
	<!---Fuentes--->	
		<tr>
			<td align="left" valign="top" id="CERRcorLabel">Fuentes: </td>
		</tr>
		<tr>
			<td nowrap>
			  <textarea rows="8" style="font-family:sans-serif; width:100%; display:block:"><cfloop query="dataSrc">#dataSrc.CERRSsrc##chr(13)#</cfloop>
			  </textarea>
			</td>
		</tr>
</cfif>
	</div>
	<!--- Portles de Botones --->
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		<tr>
			<td nowrap colspan="2" align="center">
				<cfinclude template="/sif/portlets/pBotones.cfm">
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
</cfoutput>
</form>

<cf_qforms>
	<cf_qformsRequiredField name="CERRcod" description="Codigo">
		<cf_qformsRequiredField name="CERRmsg" description="Descripción">
</cf_qforms>
<script language="javascript1.1" type="text/javascript">
	<cfif len(trim(CERRref))>
			funOcultar();
	</cfif>
	function funOcultar()
	{ 
		document.form1.CERRdes.style.display = 'none'; 	
		document.form1.CERRcor.style.display = 'none'; 	
		document.getElementById("CERRdesLabel").style.display 	= 'none';
		document.getElementById("CERRcorLabel").style.display 	= 'none';
	}
	function funMostrar()
	{
		document.form1.CERRdes.style.display = 'block'; 
		document.form1.CERRcor.style.display = 'block'; 	
		document.getElementById("CERRdesLabel").style.display 	= 'block';
		document.getElementById("CERRcorLabel").style.display 	= 'block';
	}
</script>