<cfif isdefined("url.RHCconcurso") and len(trim(url.RHCconcurso))>
	<cfset form.RHCconcurso = url.RHCconcurso>
</cfif>

<script type="text/javascript" language="javascript1.2">
	var popUpWin2 = 0;
	function popUpWindow2(URLStr, left, top, width, height){
		if(popUpWin2){
			if(!popUpWin2.closed) popUpWin2.close();
		}
			popUpWin2 = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}	

	//Popup con info
	function informe(llave){	 	
		document.formPaso1.RHCPid.value = llave;
		var param =''
		param = '?RHCPid='+llave+'&RHCconcurso='+document.formPaso1.RHCconcurso.value
		popUpWindow2("../Reportes/RH_infCalificaciones.cfm"+param,120,150,750,400);
	}

	function Expendiente(llave,tipo){
		var PARAM  = "Expediente_concursante.cfm?DEid="+ llave+ "&tipo="+ tipo
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
	}

	//Popup para reasignar plazas
	function funcReasignar(parId, parTipo,Id){	
		//Parametros: cod Concurso(RHCconcurso), plazas ya asignadas (plazas), id del empleado u oferente (id), tipo externo o interno (tipo), plaza asignada si la tiene (pasignada)		
		param ='?RHCconcurso='+document.formPaso1.RHCconcurso.value+'&plazas='+document.formPaso1.pAsignadas.value+'&id='+parId+ '&id2='+Id+'&tipo='+parTipo+'&pasignada='+document.formPaso1['RHPid_'+parId].value
		document.formPaso1['plaza_'+parId].value = ''
		document.formPaso1['RHPid_'+parId].value = ''
		popUpWindow2("AdjudicacionPlazas-reasignar.cfm"+param,120,150,650,400);
	}

	//Funcion para llenar el input con las plazas que ya fueron asignadas
	function funcLlenaInput(parvalor){
		var param = '';
		if (document.formPaso1.pAsignadas.value== ''){ //Si es la primera vez
			document.formPaso1.pAsignadas.value = document.formPaso1['RHPid_'+parvalor].value
		}
		else{
			document.formPaso1.pAsignadas.value = document.formPaso1.pAsignadas.value +','+ document.formPaso1['RHPid_'+parvalor].value
		}
	}

	
	
</script>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Interno"
	Default="Interno"
	returnvariable="LB_Interno"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Externo"
	Default="Externo"
	returnvariable="LB_Externo"/>
<cf_dbfunction name="op_concat" returnvariable="concat">
<cf_translatedata name="get" tabla="RHPlazas" col="e.RHPdescripcion" returnvariable="LvarRHPdescripcion">
<cfquery name="data" datasource="#session.DSN#">
	select  a.RHCPid, 
	  	 	a.RHPid,
	   		a.RHAlinea,
	   		case  when a.DEid is not null 
			then b.DEnombre#concat#' '#concat#b.DEapellido1#concat#' '#concat#b.DEapellido2
			else  c.RHOnombre#concat#' '#concat#c.RHOapellido1#concat#' '#concat#c.RHOapellido2 end  as  Nombre,
	   		case  when a.DEid is not null then DEidentificacion else  RHOidentificacion end   as ident,   
	   		case  when a.DEid is not null then a.DEid else a.RHOid end as ID,
	   		case  when a.DEid is not null then 'I' else 'E' end as tipo,
	   		case when a.DEid is not null then '#LB_Interno#' else '#LB_Externo#' end as Tipo_Concursante,
	   		d.RHCPpromedio,
	   		e.RHPcodigo#concat#'-'#concat##LvarRHPdescripcion# as plaza,
			1 as pintar,
			a.RHAestado
	 
	 from RHAdjudicacion a  

	left outer join DatosEmpleado b 
	on a.Ecodigo = b.Ecodigo
	and a.DEid = b.DEid

	left outer join DatosOferentes c
	on a.Ecodigo = c.Ecodigo
	and a.RHOid = c.RHOid

	inner join RHConcursantes d
	on a.Ecodigo = d.Ecodigo
	and a.RHCconcurso = d.RHCconcurso
	and a.RHCPid = d.RHCPid

	inner join RHPlazas e
	on a.Ecodigo = e.Ecodigo
	and a.RHPid = e.RHPid  
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		and a.RHAestado in (0,10,20)
	order by d.RHCPpromedio desc
</cfquery>
<cfset concursantes_asignados = valuelist(data.RHCPid)>
<cfset plazas_asignadas = valuelist(data.RHPid)>

<!---Plazas---->
<cf_translatedata name="get" tabla="RHPlazas" col="b.RHPdescripcion" returnvariable="LvarRHPdescripcion">
<cfquery name="rsPlazas" datasource="#session.DSN#">
	select 	b.RHPcodigo,
			#LvarRHPdescripcion# as RHPdescripcion, 
			b.RHPid
	from RHPlazasConcurso a

	inner join RHPlazas b
	on a.Ecodigo = b.Ecodigo
	and a.RHPid = b.RHPid

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  a.RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		<cfif len(trim(plazas_asignadas))>
			and b.RHPid not in (#plazas_asignadas#)
		</cfif>
</cfquery>

<!---Concursantes---->
<cfquery name="_rsLista" datasource="#session.DSN#">	
	select 	RHCconcurso,
			RHCPid, 
			RHCPtipo as tipo, 
			a.DEid as ID,
			case RHCPtipo when 'I' then '#LB_Interno#' else '#LB_Externo#' end as Tipo_Concursante,
			<cf_dbfunction name="to_char" args="a.RHCPpromedio"> as RHCPpromedio, RHCPpromedio as promedio,
			DEidentificacion as ident,
			{fn concat(b.DEnombre,{fn concat(' ',{fn concat(b.DEapellido1,{fn concat(' ',b.DEapellido2)})})})} as  Nombre,
			<cfif data.recordcount gt 0 >0<cfelse>1</cfif> as pintar,
			0 as RHAestado
	
	from RHConcursantes a , DatosEmpleado b

	where a.DEid  = b.DEid 
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#" >
	  and a.RHCdescalifica = 0
	  <cfif len(trim(concursantes_asignados)) >
	  	and a.RHCPid not in (#concursantes_asignados#) 
	  </cfif>

	union
	
	select  RHCconcurso,
			RHCPid, 
			RHCPtipo as tipo, 
			a.RHOid as ID,
			case RHCPtipo when 'E' then '#LB_Externo#' else '#LB_Interno#' end as Tipo_Concursante,
			<cf_dbfunction name="to_char" args="a.RHCPpromedio"> as RHCPpromedio, RHCPpromedio as promedio,
	 		RHOidentificacion as ident,
	 		{fn concat(b.RHOnombre,{fn concat(' ',{fn concat(b.RHOapellido1,{fn concat(' ',b.RHOapellido2)})})})} as  Nombre,
			<!---1 as pintar,--->
			<cfif data.recordcount gt 0 >0<cfelse>1</cfif> as pintar,
			0 as RHAestado
			
	from RHConcursantes a , DatosOferentes b

	where a.RHOid  = b.RHOid 
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
	  and a.RHCdescalifica = 0
	  <cfif len(trim(concursantes_asignados)) >
	  	and a.RHCPid not in (#concursantes_asignados#) 
	  </cfif>
			
	order by promedio desc
</cfquery>


<!---Plazas NO asignadas--->
<cfquery name="rsDisponibles" datasource="#session.DSN#">
	select b.RHPid
	from RHPlazasConcurso a
	
	inner join RHPlazas b
	on a.Ecodigo = b.Ecodigo
	and a.RHPid = b.RHPid
	
	where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
	and b.RHPid not in ( select c.RHPid 
						from RHAdjudicacion c
						where c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and c.RHCconcurso=a.RHCconcurso
						  and c.RHAestado in (10,20) )
</cfquery>


<style type="text/css">
.flat, .flattd input {
	border:1px solid gray;
	height:19px;
}
</style>

<form name="formPaso1" method="post" action="AdjudicacionPlazas-RHAdjudicacion.cfm"><!---action="AdjudicacionPlazas.cfm?Paso=1&RHCconcurso=#form.RHCconcurso#">---->
	<cfoutput>	
		<input name="RHCPid" type="hidden" value="">
		<input name="RHCconcurso" type="hidden" value="<cfif isdefined("Form.RHCconcurso") and len(trim(form.RHCconcurso))>#Form.RHCconcurso#</cfif>">		
		<input name="GrabarReasignar" type="hidden" value="">
        <input name="IDReasignar" type="hidden" value="">
	</cfoutput>
	<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0">
		<tr>
			<td><strong><cf_translate key="LB_Nombre">Nombre</cf_translate></strong></td>
			<td><strong><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></strong></td>
			<td><strong><cf_translate key="LB_Tipo">Tipo</cf_translate></strong></td>
			<td><strong><cf_translate key="LB_Nota">Nota</cf_translate></strong></td>	
			<td>&nbsp;</td>
			<td><strong><cf_translate key="LB_Plaza">Plaza</cf_translate></strong></td>	
			<td>&nbsp;</td>
		</tr>
		<input type="hidden" name="pAsignadas" value=""><!----Input con las plazas que ya fueron asignadas--->		

		<cfset vnPlazas = ''> <!---Lista de todas las plazas de ese concurso--->		
		<cfif data.recordcount gt 0>
			<cfset vnPlazas = ValueList(data.RHPid)> <!---Lista de todas las plazas de ese concurso--->		
		</cfif>
		<cfset vnPlazas = listappend(vnPlazas, ValueList(rsPlazas.RHPid)) > <!---Lista de todas las plazas de ese concurso--->		
		
		<cfset registro = 1 >
		<input type="hidden" name="Tipo" value="">
		<cfloop list="data,_rsLista" index="sql">
			<cfset rsLista =  evaluate(sql) >
			<cfoutput query="rsLista">
				<input type="hidden" name="RHCPid_#rsLista.ID#_#rsLista.Tipo#" value="#rsLista.RHCPid#">
				<input type="hidden" name="tipo_#rsLista.ID#_#rsLista.Tipo#" value="#rsLista.tipo#">
				<input type="hidden" name="ID" value="#rsLista.ID#">
	
				<tr class="<cfif registro mod 2>listaPar<cfelse>listaNon</cfif>">
					<td style="padding-left:2px; "><a href= javascript:Expendiente(#rsLista.ID#,'#rsLista.tipo#')>#rsLista.Nombre#</a></td>
					<td><a href= javascript:Expendiente(#rsLista.ID#,'#rsLista.tipo#')>#rsLista.ident#</a></td>
					<td><a href= javascript:Expendiente(#rsLista.ID#,'#rsLista.tipo#')>#rsLista.Tipo_Concursante#</a></td>
					<td><a href= javascript:Expendiente(#rsLista.ID#,'#rsLista.tipo#')>#rsLista.RHCPpromedio#</a></td>
					<td>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_CalificacionesParticipante"
							Default="Calificaciones Participante"
							returnvariable="LB_CalificacionesParticipante"/>
						<img border="0" onClick="javascript: informe(#rsLista.RHCPid#);" src="/cfmx/rh/imagenes/iindex.gif" alt="#LB_CalificacionesParticipante#">
					</td>				
					<td>			
					
						<cfif isdefined("vnPlazas") and len(trim(vnPlazas))>						
							<cfset rhpid = ListFirst(vnPlazas)><!---Variable con el codigo de la 1a plaza----->
							<cf_translatedata name="get" tabla="RHPlazas" col="RHPdescripcion" returnvariable="LvarRHPdescripcion">
							<cfquery name="rsDescPlaza" datasource="#session.DSN#">
								select RHPcodigo, #LvarRHPdescripcion# as RHPdescripcion
								from RHPlazas
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rhpid#">
							</cfquery>						
							
							<input type="text" name="plaza_#rsLista.ID#_#rsLista.Tipo#" class="cajasinbordeb" 
							value="<cfif rsLista.pintar eq 1>#rsDescPlaza.RHPcodigo# - #rsDescPlaza.RHPdescripcion#</cfif>" 
							size="40" readonly=""  <cfif registro mod 2>style=" background-color:##FAFAFA"</cfif>><!---Input donde se guardan las plazas ya asignadas----> 						
							<input type="hidden" name="RHPid_#rsLista.ID#_#rsLista.Tipo#" value="<cfif rsLista.pintar eq 1>#rhpid#</cfif>"><!---#rhpid#--->
							<input type="hidden" name="_RHPid_#rsLista.ID#_#rsLista.Tipo#" value="<cfif isdefined('rsLista.RHPid')>#trim(rsLista.RHPid)#</cfif>"><!---#rhpid#--->							
	
							<script type="text/javascript" language="javascript1.2"><!----Funcion para ir llenando el input con las plazas que ya fueron asignadas--->
								//funcLlenaInput('#rhpid#');
								funcLlenaInput('#rsLista.ID#_#rsLista.Tipo#');
							</script>											
							<cfset vnPlazas = ListDeleteAt(vnPlazas, 1)><!---Elimina la plaza asignada---->					
						<cfelse>
							<input type="text" name="plaza_#rsLista.ID#_#rsLista.Tipo#" class="cajasinbordeb" value="" size="40" readonly=""  <cfif registro mod 2>style=" background-color:##FAFAFA"</cfif>><!---Input donde se guardan las plazas ya asignadas----> 						
							<input type="hidden" name="RHPid_#rsLista.ID#_#rsLista.Tipo#" value=""><!---#rhpid#--->
							<input type="hidden" name="_RHPid_#rsLista.ID#_#rsLista.Tipo#" value=""><!---#rhpid#--->							
							&nbsp;
						</cfif>					
					</td>
					<td align="center">
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Reasignar"
							Default="Reasignar"
							XmlFile="/rh/generales.xml"
							returnvariable="BTN_Reasignar"/>
						
						<cfif isdefined("rsLista.RHAestado") and rsLista.RHAestado eq 0>
						<input class="flat" type=button name="Reasignar" value="#BTN_Reasignar#" onClick="javascript:funcReasignar('#rsLista.ID#_#rsLista.Tipo#','#rsLista.tipo#','#rsLista.ID#')"><cfelse><cf_translate key="LB_Aplicada">Aplicada</cf_translate></cfif></td>
				</tr>
				<cfset registro = registro + 1 >
			</cfoutput>
		</cfloop>

		<tr><td>&nbsp;</td></tr>

		<tr>
		  <td colspan="7" align="center">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Anterior"
					Default="Anterior"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Anterior"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Siguiente"
					Default="Siguiente"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Siguiente"/>
		    <cfoutput>
		      <input type="submit" name="btnAnterior" value="<< #BTN_Anterior#" />
		      <input type="submit" name="btnSiguiente" value="#BTN_Siguiente# >>" />
		    </cfoutput>			</td>
		</tr>

		<tr><td>&nbsp;</td></tr>	
	</table>
</form>