<!--- 
	Creado por Angeles Blanco
		Fecha: 11 Abril 2014

 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Errores de Compromisos'>
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

<cfif not isdefined("form.periodo")>
	<cfset MesAux = 0>
	<cfquery name="rsMesAux" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Pcodigo = 60
	</cfquery>

	<cfset MesAux = #rsMesAux.Pvalor#>
</cfif>

<cfoutput>
<form name="form" method="post" action="">
	<table width="100%">
			<tr>
				<td></td>
				<td colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
	
			<tr></tr>
			<tr>
				<td><strong>Número Nómina:</strong></td>
				<td>
					<input type="text" name="NumNomina" align="right" width="8" value="<cfif isdefined("form.NumNomina") and form.NumNomina eq NumNomina>#form.NumNomina#</cfif>">
				</td>
			
			</tr>
			
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
							<option value="#VSvalor#"<cfif (isdefined("form.mes") and form.mes eq VSvalor) or (isdefined("MesAux") NEQ 0 and #MesAux# eq VSvalor)>selected</cfif>>#VSdesc#</option>
						</cfloop>	
					</select>
				</td>				
			</tr>
			<td colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<tr></tr>
			<table width="50" align="center">
			   		<tr>
						<td><cf_botones values="Limpiar" names="Limpiar"></td>
						<td><cf_botones values="Consultar" names="Consultar">
                  		<td><input type="button" name="Exportar" class="btnNormal" value="Exportar" onclick="javascript:funcExportar();" ></td>
                  
                    </tr>
					<tr><td colspan="4">&nbsp;</td></tr>		
			<td colspan="8">
                <cfquery name="rsLista" datasource="sifinterfaces">
                    select distinct e.NRC_Id, NRC_NumNomina, convert(date,NRC_FechaNomina,103) as NRC_FechaNomina, NRC_Grupo, round(MontoComprometido,2) as Comprometido, round(MontoEjecutar,2) as Ejecutar
					from NRCE_Nomina e 
					inner join NRCD_Nomina d on e.NRC_Id = d.NRC_Id
					where 1=1
					<cfif isdefined("form.periodo") and len(trim(form.periodo)) and listgetat(form.periodo, 1) NEQ -1>
						and d.NRCD_Periodo = #listgetat(form.periodo, 1)#
					</cfif>
					<cfif isdefined("form.mes") and len(trim(form.mes)) and listgetat(form.mes,1) neq -1>
						and d.NRCD_Mes = #listgetat(form.mes,1)#
					</cfif>
					<cfif isdefined("form.NumNomina") and len(trim(form.NumNomina)) GT 0 >
						and upper(NRC_NumNomina)  like '%#Ucase(listgetat(form.NumNomina,1))#%'
					</cfif>
					<cfif isdefined("NRC_Id") and NRC_Id GT 0>
						and e.NRC_Id = #NRC_Id#
					</cfif>
					<!------group by e.NRC_Id, NRC_NumNomina, NRC_FechaNomina, NRC_Grupo--->
				</cfquery>
			</td>
    	
			</table>
		</table>
		
		<cfset Lvarnavegacion = 1>
	</form>

	<table>
	<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="cortes" value=""/>
			<cfinvokeargument name="desplegar"value=" NRC_NumNomina, NRC_FechaNomina, NRC_Grupo, Comprometido, Ejecutar"/>
			<cfinvokeargument name="etiquetas"value="Numero Nómina, Fecha Nómina, Grupo Presupuesto, Comprometido, A Ejecutar"/>
			<cfinvokeargument name="formatos" value="S,S,S,M,M"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,N"/>
			<cfinvokeargument name="align" value="center,center, center, left, left"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="interfaz925PMI-ConsultaNRCs.cfm"/>   
            <cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="keys" value="NRC_Id, NRC_NumNomina"/>
			<cfinvokeargument name="botones" value=""/>
            <cfinvokeargument name="navegacion" value=""/>
		</cfinvoke>
	</table>
		<cfif isdefined("NRC_Id") and NRC_Id GT 0>
		
		   <cfquery name="rsListaD" datasource="sifinterfaces">
                   select CPformato, NRCD_Periodo, NRCD_Mes
					from NRCD_Nomina n
					inner join #minisifdb#..CPresupuesto p on n.CPcuenta = p.CPcuenta
					where  NRC_Id = #NRC_Id#					
				</cfquery>
		<tr>&nbsp;&nbsp;<td>
		<table><td><strong>Detalle por cuenta presupuestal</strong></td>
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet1">
			<cfinvokeargument name="query" value="#rsListaD#"/>
			<cfinvokeargument name="cortes" value=""/>
			<cfinvokeargument name="desplegar"value="CPformato, NRCD_Periodo, NRCD_Mes"/>
			<cfinvokeargument name="etiquetas"value="Cuenta, Periodo, Mes"/>
			<cfinvokeargument name="formatos" value="S,S,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N"/>
			<cfinvokeargument name="align" value="center,center, center"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value=""/>   
            <cfinvokeargument name="MaxRows" value="30"/>
			<cfinvokeargument name="showLink" value="false"/>
			<cfinvokeargument name="keys" value=""/>
			<cfinvokeargument name="botones" value="Regresar"/>
            <cfinvokeargument name="navegacion" value=""/>
		</cfinvoke>
		</table>
		</td></tr>
		</cfif>
</cfoutput>

<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form'>


<script language="javascript" type="text/javascript">
	<!---function funcLimpiar()
		{
			document.form1.fltPeriodo.value = '-1';
			document.form1.fltMes.value = '-1';
		}--->
	function funcExportar()
	{
				<!---<cfif isdefined("form.periodo") and len(trim(form.periodo)) and listgetat(form.periodo, 1) NEQ -1>--->
					var Periodo = document.form.periodo.value;
			<!---	</cfif>
--->
		<!---		<cfif isdefined("form.mes") and len(trim(form.mes)) and listgetat(form.mes,1) neq -1>--->
					var Mes = document.form.mes.value;
			<!---	</cfif>--->
				
					var NumNomina = document.form.NumNomina.value;
				
		

				location.href  =  "interfaz925PMI-NRCsExportacion.cfm?Periodo="+Periodo+"&Mes="+Mes+"&NumNomina="+NumNomina;
	}
</script>


