<!--- NOTEPAD 12/12/2006 --->
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nota"
	Default="Nota"
	returnvariable="LB_Nota"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NOHAYCENTROSFUNCIONALES"
	Default="NO HAY CENTROS FUNCIONALES"
	returnvariable="MSG_NOHAYCENTROSFUNCIONALES"/>	

<!--- Par�metro del ID de la Relaci�n --->
<cfset params = '' >
<cfif isdefined('form.REid')>
	<cfset params = params & 'REid=#form.REid#'>
</cfif>

<!--- FIN VARIABLES DE TRADUCCION --->
<cfquery name="rs_evaluacion_header" datasource="#session.DSN#">
	select REdescripcion, REdesde
	from RHRegistroEvaluacion 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.ECODIGO#">
	and REid = <cfif isdefined("form.REid") and len(trim(form.REid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#"><cfelse>0</cfif>
</cfquery>

<cfif isdefined('form.CFid')>
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFcodigo,CFdescripcion
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
</cfif>

<cfquery name="rsNotasCF" datasource="#session.DSN#">
	select 1
	from RHNotasIndicadoresCF
	where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
</cfquery>

<!--- SI NO ESTAN REGISTRADOS LOS CENTROS FUNCIONALES DE LA EVALUACION ENTONCES SE REGISTRAN --->
<cfif rsNotasCF.RecordCount EQ 0>
	<cfquery name="rsInsertNotas" datasource="#session.DSN#">
		insert into RHNotasIndicadoresCF(REid, CFid, Ecodigo, Nota, BMUsucodigo, BMfechaalta)
			select #form.REid#,b.CFid,#session.Ecodigo#,0,#session.Usucodigo#,#Now()#
			from RHGruposRegistroE a
			inner join RHCFGruposRegistroE b
			on b.GREid = a.GREid
			inner join CFuncional cf
			   on cf.CFid = b.CFid
			  and cf.Ecodigo = a.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
</cfif>
<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<cfoutput>
	<form name="form1" method="post" action="NotasIndicadoresCF-sql.cfm" style="margin:0;">
		<input name="REid" type="hidden" value="#form.REid#" tabindex="-1">
		<table width="100%" border="0">
			<tr><td colspan="2">&nbsp;</td></tr>	
			<cfif rs_evaluacion_header.RecordCount gt 0>
		  		<tr>
		    		<td colspan="2" class="subtitulo_seccion_small" align="left">
						<strong><font color="##000099">
							#rs_evaluacion_header.REdescripcion#&nbsp;Vigencia&nbsp;#LSDateFormat(rs_evaluacion_header.REdesde,'dd/mm/yyyy')#
						</font></strong>
					</td>
				</tr>
		  	</cfif>
			<tr><td colspan="2">&nbsp;</td></tr>	
			<tr>
				<td width="50%">
					<cfset nota = "'<input type=''text'' name=''Nota_'+convert(varchar,b.CFid)+''' value='''+convert(varchar,icf.Nota)+''' onkeyup=''javascript:if(snumber(this,event,-1)){ if(Key(event)=="&13&") {this.blur();}}'' onblur=''javascript: fm(this,0); valida(this);'' maxlength=''5'' size=''5''>' nota">
					<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaRHRet">
							<cfinvokeargument name="tabla" value="RHGruposRegistroE a
																	inner join RHCFGruposRegistroE b
																	on b.GREid = a.GREid
																	inner join CFuncional cf
																	   on cf.CFid = b.CFid
																	  and cf.Ecodigo = a.Ecodigo
																	inner join RHNotasIndicadoresCF icf
																	   on icf.REid = a.REid
																	  and icf.CFid = cf.CFid
																	  and icf.Ecodigo = cf.Ecodigo"/>
							<cfinvokeargument name="columnas" value="a.REid,b.CFid
																	, CFcodigo
																	, CFdescripcion,
																	#nota#"/>
							<cfinvokeargument name="desplegar" value="CFcodigo
																	,CFdescripcion
																	,nota"/>
							<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_Nota#"/>
							<cfinvokeargument name="formatos" value="S, S, S"/>
							<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo#
																	and a.REid = #form.REid#
																	order by CFdescripcion"/>
																	
							<cfinvokeargument name="align" value="left, lef t,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="NotasIndicadoresCF-sql.cfm"/>
							<cfinvokeargument name="showlink" value="false">
							<cfinvokeargument name="showEmptyListMsg" value="true">
							<cfinvokeargument name="EmptyListMsg" value="*** #MSG_NOHAYCENTROSFUNCIONALES# ***">
							<cfinvokeargument name="botones" value="Guardar,Importar,Regresar">
							<cfinvokeargument name="navegacion" value="#params#">
							<cfinvokeargument name="index" value="2">
				  	</cfinvoke>
				</td>
			</tr>
		</table>
	</form>
</cfoutput>

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElValorDebeEstarEntre0Y100"
	Default="El Valor debe estar entre 0 y 100"
	returnvariable="MSG_ElValorDebeEstarEntre0Y100"/>	
<!--- FIN VARIABLES DE TRADUCCION --->

<script language="javascript1.2" type="text/javascript">
	function funcRegresar(){
		location.href = 'NotasIndicadoresCF.cfm';
		return false;
	}
	function valida(n){
		if (n.value < 0){
			alert('<cfoutput>#MSG_ElValorDebeEstarEntre0Y100#</cfoutput>');
			n.focus();
		}
	}
	function funcImportar(){
		var parametros = "<cfoutput>#params#</cfoutput>";
		location.href = "ImportadorNotasIndicadoresCF.cfm?" + parametros;
		return false;
	}
</script>