<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfset Error= "'<img border=''0'' src=''/cfmx/sif/imagenes/stop.gif''>&nbsp;'">


<cfquery name="rsLista" datasource="#session.DSN#">
	select a.CRCTid,
		   rtrim(e.CRTDcodigo) #_Cat# '-' #_Cat# rtrim(e.CRTDdescripcion) as CRTipoDocumento, 
	       c.Aplaca ,
		   c.Adescripcion as Activo,
		   case a.Type when 1 then 'Retiro de Activos' when 2 then 'Traslados Responsable' end transaccion, 
		   crb.CRBfecha FechaAplicacion,
		   rtrim(f.CFcodigo) #_Cat# '-' #_Cat# rtrim(f.CFdescripcion) as CFuncional, 
		   usu.Usulogin,
		   case when CRCestado > 0 then #PreserveSingleQuotes(Error)# else '' end Error
		from CRColaTransacciones a
		inner join Activos c
			on a.Aid = c.Aid
		left outer join AFResponsables af 
			on af.Ecodigo = c.Ecodigo 
	       and af.Aid = c.Aid
		  <!--- and getdate() between af.AFRfini and af.AFRffin--->
		left outer join CRTipoDocumento e 
			on af.Ecodigo = e.Ecodigo 
			and af.CRTDid =e.CRTDid
		left outer join CFuncional f 
			on af.Ecodigo = f.Ecodigo 
		    and af.CFid   = f.CFid 
		left outer join  CRBitacoraTran crb 
			on crb.CRBid = a.CRBid 
			and crb.Ecodigo = a.Ecodigo
		left join Usuario usu 
			on crb.BMUsucodigo = usu.Usucodigo 
		
		where a.Ecodigo = #session.Ecodigo#
		<!---Selecciona el Máximo documento de responsabilidad y no el vigente, ya que algunas transacciones no tienen vale y no presentaría el tipo de documento ni el CF--->
		 and (af.AFRid  = (select max(mx.AFRid) from AFResponsables mx where mx.Ecodigo = c.Ecodigo and mx.Aid = c.Aid) OR af.AFRid is null)
	 <cfif isdefined ('form.Filtro_TipoDoc') and len(trim(form.Filtro_TipoDoc))>
	 	and  lower(rtrim(e.CRTDcodigo) #_Cat# '-' #_Cat# rtrim(e.CRTDdescripcion)) like lower('%#form.Filtro_TipoDoc#%')
	 </cfif>
	 <cfif isdefined ('form.Filtro_Aplaca') and len(trim(form.Filtro_Aplaca))>
	     and lower(Aplaca) like lower('%#form.Filtro_Aplaca#%')
	 </cfif>
	 <cfif isdefined('form.Filtro_Adescripcion') and len(trim(form.Filtro_Adescripcion))>
	 	and lower(Adescripcion) like  lower('%#form.Filtro_Adescripcion#%')
	 </cfif>
	  <cfif isdefined('form.Filtro_FechaAplicacion') and len(trim(form.Filtro_FechaAplicacion))>
	 	and  CRBfecha >= #lsparsedatetime(form.Filtro_FechaAplicacion)# 
	 </cfif>
	 <cfif isdefined('form.Filtro_CFuncional') and len(trim(form.Filtro_CFuncional))>
	 	and lower(rtrim(f.CFcodigo) #_Cat# '-' #_Cat# rtrim(f.CFdescripcion)) like lower('%#form.Filtro_CFuncional#%')
	 </cfif>
	 order by a.Type, c.Aplaca
</cfquery>
<form name="filtro" action="CierreCtrResp.cfm" method="post">
<table width="98%" border="0" cellspacing="0" cellpadding="0" style="margin:0" class="AreaFiltro">
 <cfoutput>
	<tr>
		<td>&nbsp;</td>
		<td width="26%" align="center"><strong>Tipo Documento</strong></td>
	  	<td width="23%" align="center"><strong>Placa</strong></td>
		<td width="17%" align="center"><strong>Activo</strong></td>
		<td width="11%" align="center"><strong>Fecha</strong></td>
		<td width="23%" align="center"><strong>Centro Funcional</strong></td>
	</tr>
	<tr>
		<td width="0%">&nbsp;</td>
		<td align="center"><input name="Filtro_TipoDoc" type="text" size="40" value="<cfif isdefined('form.Filtro_TipoDoc') and len(trim('form.Filtro_TipoDoc'))>#form.Filtro_TipoDoc#</cfif>"/></td>
		<td align="center"><input name="Filtro_Aplaca" type="text" size="20" value="<cfif isdefined('form.Filtro_Aplaca') and len(trim('form.Filtro_Aplaca'))>#form.Filtro_Aplaca#</cfif>"/></td>
		<td align="center"><input name="Filtro_Adescripcion" type="text" size="30" value="<cfif isdefined('form.Filtro_Adescripcion') and len(trim('form.Filtro_Adescripcion'))>#form.Filtro_Adescripcion#</cfif>"/></td>
		<td align="center"><cfif isdefined('form.Filtro_FechaAplicacion') and len(trim(form.Filtro_FechaAplicacion))><cf_sifcalendario name="Filtro_FechaAplicacion" form="filtro" value="#form.Filtro_FechaAplicacion#"><cfelse><cf_sifcalendario name="Filtro_FechaAplicacion" form="filtro" value=""></cfif></td>
		<td align="center"><input name="Filtro_CFuncional" type="text" value="<cfif isdefined('form.Filtro_CFuncional') and len(trim('form.Filtro_CFuncional'))>#form.Filtro_CFuncional#</cfif>"/></td>
	    <td width="0%" valign="middle"><cf_botones values="Filtrar"></td>
	</tr>
 </cfoutput>
</table>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
	<cfinvokeargument name="query" 			  value="#rsLista#"/>
	<cfinvokeargument name="desplegar"  	  value="CRTipoDocumento,Aplaca,Activo,FechaAplicacion, CFuncional,Usulogin,ERROR "/>	
	<cfinvokeargument name="etiquetas"        value="&nbsp;,&nbsp;,&nbsp;,&nbsp;,&nbsp;,&nbsp;,&nbsp;">
	<cfinvokeargument name="formatos"   	  value="S,S,S,D,S,S, S"/>
	<cfinvokeargument name="align" 			  value="left,left,left,left,left,left,left"/>
	<cfinvokeargument name="irA"              value=""/>
	<cfinvokeargument name="keys"             value="CRCTid"/>
	<cfinvokeargument name="funcion"   		  value="ViewError"/>
	<cfinvokeargument name="fparams"   		  value="CRCTid"/>
	<cfinvokeargument name="cortes"   		  value="transaccion"/>
</cfinvoke>

</form>
<script language="javascript" type="text/javascript">
	function ViewError(CRCTid)
	{
		var PARAM  = "Pop-upCierreCtrResp.cfm?CRCTid="+CRCTid;
		window.open(PARAM,'','left=250,top=250,menubar=no,toolbar=no,scrollbars=false,resizable=false,width=500,height=300');
	}
</script>