<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif isdefined("url.FAM01COD") and len(trim(url.FAM01COD)) and not isdefined("form.FAM01COD")>
	<cfset form.FAM01COD = url.FAM01COD>
</cfif>

<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
   		<td align="center">
			<cfinclude template="formatos_tipo_doc-form.cfm">	
		</td>
  	</tr>
	<tr>
		<td width="50%" valign="top">
			<cfquery name="lista" datasource="#session.DSN#">
				select a.FAM01COD, a.FMT01COD as FMT, a.CCTcodigo as CCTcod, '3' as Paso, b.FAX01ORIGEN #_Cat# '-'#_Cat# b.OIDescripcion as Origen, a.FAX01ORIGEN as FaxOrigen
				from FAM001D a
					inner join OrigenesInterfazPV b
						 on a.Ecodigo 	  = b.Ecodigo
						and a.FAX01ORIGEN = b.FAX01ORIGEN
				where a.Ecodigo = #session.Ecodigo#
				and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM01COD#">	
				order by a.FMT01COD, a.CCTcodigo
			</cfquery>
					
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#lista#"/>
				<cfinvokeargument name="desplegar" value="FMT, CCTcod, Origen"/>
				<cfinvokeargument name="etiquetas" value="Documento, Transacci&oacute;n, Origen"/>
				<cfinvokeargument name="formatos" value="V, V, V"/>
				<cfinvokeargument name="align" value="left, left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="cajasProceso.cfm?Paso=3"/>
				<cfinvokeargument name="keys" value="FAM01COD, CCTcod,FaxOrigen"/>
				<cfinvokeargument name="PageIndex" value="2"/>					
				<cfinvokeargument name="incluyeForm" value="false"/>										
				<cfinvokeargument name="funcion" value="selReg"/>									
				<cfinvokeargument name="fparams" value="FAM01COD,CCTcod,FaxOrigen"/>													
				<cfinvokeargument name="showemptylistmsg" value="true"/>
				<cfinvokeargument name="navegacion" value="FAM01COD=#form.FAM01COD#"/>
			</cfinvoke>
		</td>
	</tr>		
</table>
		
<script language="javascript" type="text/javascript">
	function selReg(fam,cct,fxo){
		document.form1.CCTCOD.value=cct;
		document.form1.FAM01COD.value=fam;
		document.form1.FaxOrigen.value=fxo;
		document.form1.PASO.value='3';
		document.form1.action='cajasProceso.cfm';		
		document.form1.submit();
	}
</script>