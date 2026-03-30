<!--- <cfdump var="#form#">  --->
 <cfif isdefined("url.RHCconcurso") and not isdefined("form.RHCconcurso")>
	<cfset form.RHCconcurso = url.RHCconcurso>
</cfif>
 <cfif isdefined("url.RHCPid") and not isdefined("form.RHCPid")>
	<cfset form.RHCPid = url.RHCPid>
</cfif>

<cfif isDefined("session.Ecodigo") and isDefined("Form.RHCconcurso") and len(trim(#Form.RHCconcurso#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
	<cfquery name="rsRHConcursos" datasource="#Session.DSN#">
		Select RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion, RHPcodigo, RHCcantplazas, RHCfcierre, RHCestado
        from RHConcursos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >		  
		order by RHCdescripcion asc
	</cfquery>
	<cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
	<cfquery name="rsDescpuesto" datasource="#Session.DSN#">
		Select coalesce(RHPcodigoext,RHPcodigo) as RHPcodigo,#LvarRHPdescpuesto# as RHPdescpuesto
        from RHPuestos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsRHConcursos.RHPcodigo#" >		  
	</cfquery>

	<cfquery  name="rsConcursantesCalificados" datasource="#Session.DSN#">
		select count(1) as Concursan
		from RHConcursantes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		and RHCdescalifica = 0
	</cfquery>
</cfif>

<cfoutput>
	<table width="75%" align="center"  border="0" >
		<tr>
			<td colspan="2" bgcolor="gray" align="left">
				<strong><cf_translate key="LB_InformeDeCalificacionPorConcurso" xmlFile="RegistroEvalInforme.xml">Informe de Calificación por Concurso.</cf_translate></strong>
			</td>
		</tr>
		<tr>
			<td style="border-style:solid">
				<table  width="100%"  align="center"border="0">
			<tr>
			<td>
			<strong><cf_translate key="LB_NConcurso" xmlFile="RegistroEvalInforme.xml">N&deg;. Concurso</cf_translate>:</strong></td>
			<td>#rsRHConcursos.RHCcodigo#</td>
		</tr>
		<tr>
			<td><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:</strong></td>
			<td>#rsRHConcursos.RHCdescripcion#</td>
		</tr>
		<tr>
			<td><strong><cf_translate key="LB_Puesto" xmlFile="RegistroEvalInforme.xml">Puesto</cf_translate>:</strong></td>
			<td>#rsDescpuesto.RHPcodigo# - #rsDescpuesto.RHPdescpuesto# </td>
		</tr>
		<tr>
			<td><strong><cf_translate key="LB_NPlazas" xmlFile="RegistroEvalInforme.xml">N&deg;. Plazas</cf_translate>	:</strong></td>
			<td>#rsRHConcursos.RHCcantplazas# </td>
		</tr>
		<tr>
			<td height="27"><strong>
		    <cf_translate key="LB_FechaDeCierre" xmlFile="RegistroEvalInforme.xml">Fecha de cierre</cf_translate>:</strong></td>
			<td>#dateformat(rsRHConcursos.RHCfcierre,"DD/MM/YYYY")#</td>
		</tr>
		<tr>
			<td><strong><cf_translate key="LB_EstadoDelConsurso" xmlFile="RegistroEvalInforme.xml">Estado del Concurso</cf_translate>:</strong></td>
			<td>			
				<cfswitch expression="#rsRHConcursos.RHCestado#">
					<cfcase value="0"><cf_translate key="LB_EnProceso" xmlFile="RegistroEvalInforme.xml">En&nbsp;proceso</cf_translate></cfcase>
					<cfcase value="10"><cf_translate key="LB_Solicitado" xmlFile="RegistroEvalInforme.xml">Solicitado</cf_translate></cfcase>
					<cfcase value="20"><cf_translate key="LB_Desierto" xmlFile="RegistroEvalInforme.xml">Desierto</cf_translate></cfcase>
					<cfcase value="30"><cf_translate key="LB_Cerrado" xmlFile="RegistroEvalInforme.xml">Cerrado</cf_translate></cfcase>
					<cfcase value="15"><cf_translate key="LB_Verificado" xmlFile="RegistroEvalInforme.xml">Verificado</cf_translate></cfcase>
					<cfcase value="40"><cf_translate key="LB_Revision" xmlFile="RegistroEvalInforme.xml">Revision</cf_translate></cfcase>
					<cfcase value="50"><cf_translate key="LB_Aplicado" xmlFile="RegistroEvalInforme.xml">Aplicado</cf_translate></cfcase>
					<cfcase value="60"><cf_translate key="LB_Evaluado" xmlFile="RegistroEvalInforme.xml">Evaluado</cf_translate></cfcase>
					<cfcase value="70"><cf_translate key="LB_Terminado" xmlFile="RegistroEvalInforme.xml">Terminado</cf_translate></cfcase>
				</cfswitch>
			</td>
		</tr>
		</table>
		</td>
		</tr>
	</table>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Interno"
	Default="Interno"
	returnvariable="LB_Interno" xmlFile="RegistroEvalInforme.xml"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Externo"
	Default="Externo"
	returnvariable="LB_Externo" xmlFile="RegistroEvalInforme.xml"/>	

<!--- lista concursantes calificados --->
<table width="75%" border="0" align="center">
	<tr><td colspan="2" align="center">&nbsp;</td></tr>
	<td colspan="2"  align="center"  bgcolor="gray" valign="top"><strong><cf_translate key="LB_ListaDeConsursantes" xmlFile="RegistroEvalInforme.xml">Lista de Concursantes</cf_translate></strong></td>
	<tr>
		<td colspan="2"style="border-style:solid">
			<cf_dbfunction name="to_char" args="a.DEid" returnvariable="vDEid">
			<cf_dbfunction name="to_char" args="a.RHCPpromedio"  returnvariable="vRHCPpromedio">
			<cf_dbfunction name="to_char" args="a.RHCPid"  returnvariable="vRHCPid">
			<cf_dbfunction name="to_char" args="a.RHOid"   returnvariable="vRHOid">
			

			<cfquery name="rsLista" datasource="#session.DSN#">	
				
				select  RHCconcurso,RHCPid,
				case RHCPtipo when 'I' then 
				<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vDEid#|',&quot;'|RHCPtipo|'&quot;);''>'|'#LB_Interno#'|'</a>'" delimiters="|">
				else 
				<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vDEid#|',&quot;'|RHCPtipo|'&quot;);''>'|'#LB_Externo#'|'</a>'" delimiters="|">
				end as Tipo_Concursante, 
				<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vDEid#|',&quot;'|RHCPtipo|'&quot;);''>'|#vRHCPpromedio#|'</a>'" delimiters="|">as RHCPpromedio,
				RHCPpromedio as promedio,
				<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vDEid#|',&quot;'|RHCPtipo|'&quot;);''>'|DEidentificacion|'</a>'" delimiters="|"> as identificacion,
				<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vDEid#|',&quot;'|RHCPtipo|'&quot;);''>'|b.DEnombre|' '| b.DEapellido1|' '|b.DEapellido2|'</a>'" delimiters="|"> as NombreEmp,
				 case a.RHCdescalifica when 0 then 
				 	<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vDEid#|',&quot;'|RHCPtipo|'&quot;);''>'|'<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''></a>'" delimiters="|">
				 else 
				 	<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vDEid#|',&quot;'|RHCPtipo|'&quot;);''>'|'<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''></a>'" delimiters="|">
				 end as descalificado,
				{fn concat('<img border=''0'' onClick=''informe(',{fn concat(<cf_dbfunction name="to_char" args="a.RHCPid">,');'' src=''/cfmx/rh/imagenes/iindex.gif'' alt=''Calificaciones Participante'' >')})}  as borrar	
			
				from RHConcursantes a , DatosEmpleado b
				where  a.DEid  = b.DEid 
				and  RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCconcurso#" >
				
				union
				
				select  RHCconcurso,RHCPid,
				case RHCPtipo when 'I' then 
				<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vRHOid#|',&quot;'|RHCPtipo|'&quot;);''>'|'#LB_Interno#'|'</a>'" delimiters="|">
				else 
				<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vRHOid#|',&quot;'|RHCPtipo|'&quot;);''>'|'#LB_Externo#'|'</a>'" delimiters="|">
				end as Tipo_Concursante, 
				<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vRHOid#|',&quot;'|RHCPtipo|'&quot;);''>'|#vRHCPpromedio#|'</a>'" delimiters="|">as RHCPpromedio,
				RHCPpromedio as promedio,
				<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vRHOid#|',&quot;'|RHCPtipo|'&quot;);''>'|RHOidentificacion|'</a>'" delimiters="|"> as identificacion,
				<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vRHOid#|',&quot;'|RHCPtipo|'&quot;);''>'|b.RHOnombre|' '| b.RHOapellido1|' '|b.RHOapellido2|'</a>'" delimiters="|"> as NombreEmp,
				 case a.RHCdescalifica when 0 then 
				 	<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vRHOid#|',&quot;'|RHCPtipo|'&quot;);''>'|'<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''></a>'" delimiters="|">
				 else 
				 	<cf_dbfunction name="concat" args="'<a href=''javascript: Expendiente('|#vRHOid#|',&quot;'|RHCPtipo|'&quot;);''>'|'<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''></a>'" delimiters="|">
				 end as descalificado,				
				 {fn concat('<img border=''0'' onClick=''informe(',{fn concat(<cf_dbfunction name="to_char" args="a.RHCPid">,');'' src=''/cfmx/rh/imagenes/iindex.gif'' alt=''Calificaciones Participante'' >')})} as borrar 
				from RHConcursantes a , DatosOferentes b
				where  a.RHOid  = b.RHOid 
				and  RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCconcurso#" >
				
				order by promedio desc
				
				
			</cfquery>
			
			
			<!--- VARIABLES DE TRADUCCION --->
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Nombre"
				Default="Nombre"
				returnvariable="LB_Nombre" xmlFile="RegistroEvalInforme.xml"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Identificacion"
				Default="Identificación"
				returnvariable="LB_Identificacion" xmlFile="RegistroEvalInforme.xml"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_TipoConcursante"
				Default="Tipo Concursante"
				returnvariable="LB_TipoConcursante" xmlFile="RegistroEvalInforme.xml"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_NotaObtenida"
				Default="Nota&nbsp;Obtenida"
				returnvariable="LB_NotaObtenida" xmlFile="RegistroEvalInforme.xml"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Descalificado"
				Default="Descalificado"
				returnvariable="LB_Descalificado" xmlFile="RegistroEvalInforme.xml"/>
			<cfinvoke
					component="rh.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet"> 
				<cfinvokeargument name="query" value="#rsLista#"/> 
				<cfinvokeargument name="desplegar" value="NombreEmp,identificacion,Tipo_Concursante,RHCPpromedio,descalificado,borrar"/> 
				<cfinvokeargument name="etiquetas" value="#LB_Nombre#,#LB_Identificacion#,#LB_TipoConcursante#,#LB_NotaObtenida#,#LB_Descalificado#,&nbsp;"/> 
				<cfinvokeargument name="formatos" value="S,S,S,S,S,S"/> 
				<cfinvokeargument name="align" value="left,left,left,left,center,right"/> 
				<cfinvokeargument name="ajustar" value="N"/> 
				<cfinvokeargument name="checkboxes" value="N"/> 
				<cfinvokeargument name="irA" value="/cfmx/rh/Reclutamiento/Reportes/RH_infCalificaciones.cfm"/> 
				<cfinvokeargument name="keys" value="RHCPid"/> 
				<cfinvokeargument name="showEmptyListMsg" value="true"/>						
				<cfinvokeargument name="maxrows" value="10"/>
				<cfinvokeargument name="showlink" value="false"/>
			</cfinvoke>
		</td>
	</tr>
</table>


<!---  --->
	<table width="75%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center"><strong><cf_translate key="LB_TotalDeConcursantesCalificados" xmlFile="RegistroEvalInforme.xml">Total&nbsp;de&nbsp;Concusantes&nbsp;Calificados</cf_translate>:</strong></td>
			<td width="64%">&nbsp;#rsConcursantesCalificados.Concursan#</td>
		</tr>
	</table>
<cfoutput>
<form name="form1" id="form1" action="../Reportes/RH_infCalificaciones.cfm" method="post">
	<input name="RHCPid" type="hidden" value="">
	<input name="RHCconcurso" type="hidden" value="<cfif isdefined("Form.RHCconcurso")>#Form.RHCconcurso#</cfif>">
</form>
</cfoutput>

</cfoutput> 


<cf_qforms>
<script language="javascript" type="text/javascript">
	<cfoutput>
	function informe(llave){
		document.form1.RHCPid.value = llave;
		document.form1.submit();
	}
	
	function Expendiente(llave,tipo){
		var PARAM  = "Expediente_concursante.cfm?DEid="+ llave+ "&tipo="+ tipo;
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
	}
	</cfoutput>
</script>

<!---  <h1>INFORME</h1>  --->