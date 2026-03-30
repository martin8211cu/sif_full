<!--- 
	Creado por Angeles Blanco
		Fecha: 16 marzo 2010

	Modificado por Alejandro Bolaños
	Motivo: Se modifica para utilizar las tablas historicas y no las tablas de trabajo
	Fecha 22 de marzo 2012
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Rechazos de Compromisos'>
<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cfinvoke  key="LB_Periodo" default="Periodo" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Periodo" xmlfile="listaDocumentosContables.xml"/>
<cfinvoke  key="LB_Mes" default="Mes" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Mes" xmlfile="listaDocumentosContables.xml"/>
<cfinvoke  key="LB_Lote" default="Lote" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Lote" xmlfile="listaDocumentosContables.xml"/>
<cfinvoke  key="LB_Descripcion" default="Descripci&oacute;n" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Descripcion" xmlfile="listaDocumentosContables.xml"/>

<!---<cf_navegacion name="fltPeriodo" 		navegacion="" session default="-1">
<cf_navegacion name="fltMes" 		    navegacion="" session default="-1">
<cf_navegacion name="fltTipoVenta" 		navegacion="" session default="-1">
<cf_navegacion name="fltProducto" 		navegacion="" session default="-1">
<cf_navegacion name="fltTipoDoc" 		navegacion="" session default="-1">
<cf_navegacion name="Grupo1" 		navegacion="" session default="-1">
<cf_navegacion name="MovAd" 		navegacion="" session default="-1">

<cfquery name="rsPeriodo" datasource="sifinterfaces">
	select distinct(E.Periodo) as Periodo from ESIFLD_HFacturas_Venta E
	inner join DSIFLD_HFacturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
	inner join int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
	where E.Periodo is not null and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by E.Periodo desc
</cfquery>--->

<cfquery name="rsPer" datasource="#Session.DSN#" cachedwithin="#createtimespan(0,0,5,0)#">
		select distinct Speriodo as Eperiodo
		from CGPeriodosProcesados
		where Ecodigo = #session.Ecodigo#
		order by Eperiodo desc
</cfquery>

<cfquery name="rsMeses" datasource="sifControl" cachedwithin="#createtimespan(0,1,0,0)#">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
		and a.Iid = b.Iid
		and b.VSgrupo = 1
		order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<cfquery name="rsLotes" datasource="#Session.DSN#" cachedwithin="#createtimespan(0,0,5,0)#">
	select uc.Cconcepto, e.Cdescripcion
	from UsuarioConceptoContableE uc 
		inner join ConceptoContableE e
		 on e.Ecodigo = uc.Ecodigo
		and e.Cconcepto = uc.Cconcepto
	where uc.Ecodigo = #session.Ecodigo#
	  and uc.Usucodigo = #Session.Usucodigo#

	union

	select e.Cconcepto, e.Cdescripcion
	from ConceptoContableE e
	where e.Ecodigo = #session.Ecodigo#
	  and 
		(
			select count(1)
			from UsuarioConceptoContableE uc
			where uc.Ecodigo = e.Ecodigo
			  and uc.Cconcepto = e.Cconcepto
		) = 0 
</cfquery>

<cfif rsLotes.recordcount GT 0>
	<cfset LvarConceptos = valuelist(rsLotes.Cconcepto, ",")>
<cfelse>
	<cfset LvarConceptos = "-100">
</cfif>	

<cfoutput>
<form name="form" method="post" action="">
	<table width="100%">
			<tr>
				<td></td>
				<td colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td><strong>Lote:</strong></td>
				<td colspan="2"> 
						<select name="lote">
						<option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
							<cfloop query="rsLotes"> 
								<option value="#Cconcepto#"<cfif isdefined("form.lote") and form.lote eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
							</cfloop> 
						</select>
				</td>			
			</tr>
			<tr></tr>
			<tr>
				<td><strong>Numero Documento:</strong></td>
				<td>
					<input type="text" name="NumDoc" align="right" width="8"/>
				</td>
				<td><strong>Numero NRC:</strong></td>
				<td>
					<input type="text" name="NumNRC" align="right" width="8"/>
				</td>		
				
			</tr>
			<tr></tr>
			<tr>
				<td><strong>Referencia Origen:</strong></td>
				<td>
					<input type="text" name="RefOri" align="right" width="8"/>
				</td>
				<td><strong>Origen Contable:</strong></td>
				<td>
					<input type="text" name="OriConta" align="right" width="8"/>
				</td>
			</tr>
			<tr></tr>
			<tr>
				<td><strong>Periodo:</strong></td>
				<td>
					<select name="periodo">
						<cfloop query="rsPer">
							<option value="#Eperiodo#" <cfif isdefined("form.periodo") and form.periodo eq Eperiodo>selected</cfif>>#Eperiodo# </option>
						</cfloop>
					</select>
				</td>
				<td><strong>Mes:</strong></td>
				<td>
					<select name="mes">
						<cfloop query="rsMeses">
							<option value="#VSvalor#"<cfif isdefined("form.mes") and form.mes eq VSvalor>selected</cfif>>#VSdesc#</option>
						</cfloop>	
					</select>
				</td>				
			</tr>
			<!--JMRV. 08 de Abril de 2014. Inicio de Cambio. Muestra el estado del NRC-->
			<cfset OpcEstado="Activos Inactivos Todos">
			<tr>
				<td></td>
				<td></td>
				<td><strong>Estado:</strong></td>
				<td>
					<select name="estado">
						<cfloop index="OpcEstado" list="#OpcEstado#" delimiters=" ">
							<option value="#OpcEstado#"<cfif isdefined("form.estado") and form.estado eq OpcEstado>selected</cfif>>#OpcEstado#</option>
						</cfloop>
					</select>
				</td>			
			</tr>	
			<td colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<tr></tr>
			<table width="50" align="center">
			   		<tr>
						<td><cf_botones values="Limpiar" names="Limpiar"></td>
						<td><cf_botones values="Consultar" names="Consultar"></td></tr>
					<tr><td colspan="4">&nbsp;</td></tr>		
			<td colspan="8">
                <cfquery name="rsLista" datasource="#Session.DSN#">
                    select NRC_Numero, NRC_Periodo, NRC_Mes, NRC_ModuloOrigen, NRC_RefOrigen, NRC_DocumentoOrigen, NRC_Cconcepto, Estado,

                    case
					when Estado = 0
					then 'Inactivo'
					else
					'Activo'
					end
					EstadoModificado

					from MensNRCE 
					
					<cfif isdefined("form.estado") and trim(form.estado) is "Todos">
						where (Estado = 0 or Estado = 1)
					<cfelseif isdefined("form.estado") and trim(form.estado) is "Inactivos">
						where Estado = 0
					<cfelse>
						where Estado = 1
					</cfif>

					<cfif isdefined("form.periodo") and len(trim(form.periodo)) and listgetat(form.periodo, 1) NEQ -1>
						and NRC_Periodo = #listgetat(form.periodo, 1)#
					</cfif>
					<cfif isdefined("form.mes") and len(trim(form.mes)) and listgetat(form.mes,1) neq -1>
						and NRC_Mes = #listgetat(form.mes,1)#
					</cfif>
					<cfif isdefined("form.lote")  and len(trim(form.lote)) and listgetat(form.lote,1) NEQ -1>
						and NRC_Cconcepto = #listgetat(form.lote,1)#
					</cfif>
					<cfif isdefined("form.OriConta") and len(trim(form.OriConta)) GT 0 >
						and upper(NRC_ModuloOrigen)  like '%#Ucase(listgetat(form.OriConta,1))#%'
					</cfif>
					<cfif isdefined("form.RefOri") and len(trim(form.RefOri)) GT 0 >
						and upper(NRC_RefOrigen)  like '%#Ucase(listgetat(form.RefOri,1))#%'
					</cfif>
					<cfif isdefined("form.NumNRC") and len(trim(form.NumNRC)) GT 0 >
						and NRC_Numero = #form.NumNRC#
					</cfif>
					<cfif isdefined("form.NumDoc") and len(trim(form.NumDoc)) GT 0 >
						and upper(NRC_DocumentoOrigen)  like '%#Ucase(listgetat(form.NumDoc,1))#%'
					</cfif>
				</cfquery>
			</td>
    	
			</table>
		</table>
		
		<cfset Lvarnavegacion = 1>
	</form>

	<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="cortes" value=""/>
			<cfinvokeargument name="desplegar"value="NRC_Numero, NRC_Periodo, NRC_Mes, NRC_ModuloOrigen, NRC_DocumentoOrigen, NRC_RefOrigen,  NRC_Cconcepto, EstadoModificado">
			<cfinvokeargument name="etiquetas"value="Numero NRC, Periodo,Mes, Modulo, Documento, Ref Origen, Lote, Estado"/>
			<cfinvokeargument name="formatos" value="S,S,S,S,S,S,S,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N,N"/>
			<cfinvokeargument name="align" value="center,center, center, center, center, center, center, center"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="ConsultaNRC-exportacion.cfm"/>   
            <cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="keys" value="NRC_Numero"/>
			<cfinvokeargument name="botones" value=""/>
            <cfinvokeargument name="navegacion" value=""/>
	</cfinvoke>
	<!--JMRV. 08 de Abril de 2014. Muestra el estado del NRC. Fin del Cambio-->
</cfoutput>

<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form'>


<script language="javascript" type="text/javascript">
	function funcLimpiar()
		{
			document.form1.fltPeriodo.value = '-1';
			document.form1.fltMes.value = '-1';
			document.form1.fltTipoVenta.value = '-1';
			document.form1.fltTipoDoc.value = '-1';
			document.form1.Grupo1.value = 'Ninguno';
		}
	function funcConsultar()
	{
		document.form1.action = "ConsultaNRC-exportacion.cfm";
	}
</script>


