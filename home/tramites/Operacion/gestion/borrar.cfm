<script language="javascript1.2" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function infoRequisito(requisito) {
		var params ="";
		params = "?id_requisito="+requisito;
		popUpWindow("/cfmx/home/tramites/Operacion/gestion/infoRequisito.cfm"+params,250,200,650,400);
	}
</script>

<!--- puedo hacer el mismo tramite mas de una vez ?????????? --->
<cfquery name="persona" datasource="#session.tramites.dsn#">
	select p.id_persona
	from TPPersona p
	where p.identificacion_persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.identificacion_persona#">
</cfquery>
<cfif persona.recordcount eq 0 >
<cfthrow message="Error. La persona no existe.">
</cfif>

<cfquery name="tramite" datasource="#session.tramites.dsn#" maxrows="1">
	select id_instancia
	from TPInstanciaTramite
	where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
	  and id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#persona.id_persona#">
	  and completo = 0
</cfquery>

<cfif tramite.recordcount gt 0>
	<cfquery name="instancia" datasource="#session.tramites.dsn#" >
		select 	#persona.id_persona# as id_persona,
				it.id_instancia, 
				it.id_tramite, 
				ir.fecha_registro, 
				ir.completado, 
				p.nombre || ' ' || ' ' || apellido1 || '' || apellido2 as nombre,
				rt.id_requisito, 
				rt.numero_paso, 
				r.codigo_requisito, 
				r.nombre_requisito,
				r.es_pago,
				r.es_capturable,
				r.es_cita,
				0 as permisos
		from TPInstanciaTramite it
		
		inner join TPInstanciaRequisito ir
		on ir.id_instancia = it.id_instancia
		
		left join TPFuncionario f
		on f.id_funcionario = ir.id_funcionario
		
		left join TPPersona p
		on p.id_persona = f.id_persona
		
		inner join TPRReqTramite rt
		on rt.id_requisito = ir.id_requisito
		and rt.id_tramite=it.id_tramite
		
		inner join TPRequisito r
		on r.id_requisito=rt.id_requisito
		
		where it.id_tramite=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
		and it.id_persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#persona.id_persona#">
		and it.id_funcionario=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">
		and it.id_instancia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#tramite.id_instancia#">
		
		order by rt.numero_paso
	</cfquery>
<cfelse>
	<cfquery name="instancia" datasource="#session.tramites.dsn#">
		select  #persona.id_persona# as id_persona,
				0 as id_instancia, 
				#url.id_tramite# as id_tramite, 
				null as fecha_registro, 
				0 as completado, 
				'' as nombre,
				rt.id_requisito, 
				rt.numero_paso, 
				r.codigo_requisito, 
				r.nombre_requisito,
				r.es_pago,
				r.es_capturable,
				r.es_cita,
				0 as permisos
		from TPRReqTramite rt
		
		inner join TPRequisito r
		on r.id_requisito = rt.id_requisito
		
		where rt.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
		order by rt.numero_paso
	</cfquery>	
</cfif>

<!--- PERMISOS DEL FUNCIONARIO --->
<!---
<cfquery name="institucion" datasource="#session.tramites.dsn#">
	select f.id_inst, id_tipoinst
	from TPFuncionario f
	
	inner join TPInstitucion i
	on i.id_inst = f.id_inst
	
	left join TPRTipoInst ti
	on ti.id_inst = i.id_inst
	
	where id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">
</cfquery>
<cfset tipos_inst = valuelist(institucion.id_tipoinst) >

<cfquery name="puede" datasource="#session.tramites.dsn#">
	select id_requisito
	from TPRFuncionarioReq
	where id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">
	  and puede_capturar = 1
	
	union
	
	select id_requisito
	from TPRInstitucionReq
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#institucion.id_inst#">
	  and puede_capturar = 1
	  
	<cfif isdefined("tipos_inst") and len(trim(tipos_inst))>
		union
		
		select id_requisito
		from TPRTipoInstReq
		where id_tipoinst in (#tipos_inst#)
   	      and puede_capturar = 1
	</cfif>	  
</cfquery>
<cfset requisitos = valuelist(puede.id_requisito) >
--->


<cfoutput>
	<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr bgcolor="##F5F5F5">
			<td width="1%">&nbsp;</td>
			<td width="70%" colspan="2"><strong>Requisito</strong></td>
			<td width="24%"><strong>Fecha</strong></td>
			<td width="5%">&nbsp;</td>
		</tr>

		<cfloop query="instancia">
			<tr bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>">
				<cfif instancia.completado eq 1>
					<cfset link = 'req_cumplido.cfm'>
					<cfset img = 'check-verde.gif'>
				<cfelseif instancia.permisos eq 0>
					<cfset link = ''>
					<cfset img = 'candado.gif'>
				<cfelseif instancia.es_pago eq 1>
					<cfset link = 'req_pago.cfm'>
					<cfset img = 'plata.gif'>
				<cfelseif instancia.es_cita eq 1>
					<cfset link = 'req_cita.cfm'>
					<cfset img = 'cita.gif'>
				<cfelseif instancia.es_capturable eq 1>
					<cfset link = 'req_aprobar.cfm'>
					<cfset img = 'blank.gif'>
				<cfelse>
					<cfset link = 'req_requisito.cfm'>
					<cfset img = 'no-esta.gif'>
				</cfif>

				<cfif Len(link)>
					<cfset link = link & "?id_persona=#instancia.id_persona#">
					<cfset link = link & "&id_instancia=#instancia.id_instancia#">
					<cfset link = link & "&id_tramite=#url.id_tramite#">
					<cfset link = link & "&id_requisito=#instancia.id_requisito#">
					<cfset link = "href='" & link & "'" >
				</cfif>

				<td width="1%"><a style="font-size:16px" #link# ><img src="/cfmx/home/tramites/images/#img#" border="0"></a></td>
				<td><a style="font-size:16px" #link# >#CurrentRow#</a></td>
				<td><a style="font-size:16px" #link# >#trim(instancia.codigo_requisito)# - #instancia.nombre_requisito#</a></td>
				<td><a style="font-size:16px" #link# ><cfif len(trim(instancia.fecha_registro))>#LSDateFormat(instancia.fecha_registro,'dd/mm/yyyy')#</cfif></a></td>
				<td><img style="cursor:hand;" alt="Ver Detalle del Requisito #trim(instancia.codigo_requisito)# - #instancia.nombre_requisito#" src="/cfmx/home/tramites/images/lupa.gif" border="0" onClick="javascript:infoRequisito(#instancia.id_requisito#)"></td>
			</tr>
		</cfloop>
	
		<tr>
			<td colspan="4">
				<blockquote style="border:1px solid gray ">
					<div style="cursor:pointer;background-color:##ededed" id="leyenda_requisitos_titulo" onclick="var x=document.getElementById('leyenda_requisitos_contenido');if(x){x.style.display=x.style.display=='none'?'block':'none';}"><strong><em>Leyenda:</em></strong></div>
					<div id="leyenda_requisitos_contenido" style="display:none;">
						<img src="/cfmx/home/tramites/images/check-verde.gif"> Terminado<br>
						<img src="/cfmx/home/tramites/images/candado.gif"> No tiene permisos<br>
						<img src="/cfmx/home/tramites/images/plata.gif"> Requiere pago previo<br>
						<img src="/cfmx/home/tramites/images/cita.gif"> Sacar cita<br>
						<img src="/cfmx/home/tramites/images/no-esta.gif"> No est&aacute; en el expediente
					</div>
				</blockquote>
			</td>
		</tr>
	</table>
</cfoutput>