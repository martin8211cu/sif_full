<!--- 
	Creado por Angeles Blanco
		Fecha: 12 Agosto 2010
		
	Modificado por Alejandro Bolaños
	Motivo: Se modifica para utilizar las tablas historicas y no las tablas de trabajo
	Fecha 22 de marzo 2012
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Saldos por Volumen de Ventas'>

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">
<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cf_navegacion name="fltPeriodo" 		navegacion="" session default="-1">
<cf_navegacion name="fltMes" 		    navegacion="" session default="-1">

<cfset GvarEcodigo   = Session.Ecodigo>
<cfset GvarUsucodigo = Session.Usucodigo>	

<cfoutput>
<cfset LvarNavegacion = ""> 

<cfif Form.fltPeriodo NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltPeriodo=#Form.fltPeriodo#">
</cfif>

<cfif Form.fltMes NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltMes=#Form.fltMes#">
</cfif>

<cfquery name="rsValores" datasource="sifinterfaces">
	select  I.Ecodigo, sum(isnull(Vol_Barriles,0)) as Vol_Barriles, E.Periodo, E.Mes,
	Clas_Venta_Lin, Clas_Item, E.Clas_Venta, CCTtipo 
	from ESIFLD_HFacturas_Venta E
	inner join DSIFLD_HFacturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
	inner join int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
	inner join #minisifdb#..CCTransacciones T on T.CCTcodigo = E.Tipo_Documento and T.Ecodigo = I.Ecodigo
	where E.Periodo is not null and E.Mes is not null and E.Contabilizado = 0 and Estatus = 2 and I.Ecodigo = 
	<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
	and ((Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
	Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
	or  (Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
	Mes <= 12))
	group by E.Periodo, E.Mes, Clas_Venta_Lin, D.Clas_Item, I.Ecodigo, E.Clas_Venta, T.CCTtipo
</cfquery>

<cfif rsValores.recordcount EQ 0>
	<cfthrow message="No existen registros nuevos para procesar">
</cfif>

<!---Verifica periodo y mes activos en la contabilidad---->				
<cfquery name="rsVerificaPeriodo" datasource="#session.dsn#">
	select (select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=                 "#GvarEcodigo#"> and Pcodigo = 60) as Mes,
    (select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=                    "#GvarEcodigo#"> and Pcodigo = 50) as Año
</cfquery>

<cfquery datasource="#session.dsn#">
	delete AnexoVolumen where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
</cfquery>			
			
<cfloop query="rsValores">
	<!----Valida que el mes haya sido cerrado---->
	<cfset Valido = false>				
	<cfif form.fltPeriodo LT rsVerificaPeriodo.Año>
	 	<cfset Valido = true>
	<cfelseif rsVerificaPeriodo.Año EQ form.fltPeriodo and form.fltMes LT rsVerificaPeriodo.Mes>
	 	<cfset Valido = true>
	</cfif>
				       				 				
	<cfif Valido EQ true> 
		<cfquery name="rsVerifica" datasource="#session.dsn#">
	    	select Ecodigo, Periodo, Mes, CCTtipo, Cod_Item, Clas_Venta_Lin from AnexoVolumen
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Ecodigo#">
			and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Periodo#"> 
			and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Mes#"> 
			and Cod_Item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Clas_Item#">
			and Clas_Venta_Lin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Clas_Venta_Lin#"> 					    	    and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Clas_Venta#">
			and Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
		</cfquery>
		
		<cfif rsVerifica.recordcount EQ 0>		
			<cfquery datasource="#session.dsn#">
				insert into AnexoVolumen
				(Ecodigo, Periodo, Mes, Clas_Venta, Cod_Item, CCTtipo, Clas_Venta_Lin, Volumen, Usuario)
				values
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Periodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Mes#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Clas_Venta#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Clas_Item#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.CCTtipo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Clas_Venta_Lin#">,
				<cfif rsValores.CCTtipo EQ 'D'>
					<cfqueryparam cfsqltype="cf_sql_double" value="#rsValores.Vol_Barriles#">,
				<cfelse>
					-1 * <cfqueryparam cfsqltype="cf_sql_double" value="#rsValores.Vol_Barriles#">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">) 
			</cfquery>						
		<cfelse>
			<cfquery datasource="#session.dsn#">
			    update AnexoVolumen
			    set 
				<cfif rsValores.CCTtipo EQ 'D'>
				   	Volumen = Volumen + <cfqueryparam cfsqltype="cf_sql_double" value="#rsValores.Vol_Barriles#">
				<cfelse>
					Volumen = Volumen - <cfqueryparam cfsqltype="cf_sql_double" value="#rsValores.Vol_Barriles#">
				</cfif>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Ecodigo#">
				and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Periodo#"> 
				and	Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Mes#"> 
				and Cod_Item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Clas_Item#">
				and Clas_Venta_Lin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Clas_Venta_Lin#">
   				and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Clas_Venta#">
			</cfquery>
		</cfif>
	<cfelse>
		<cfthrow message="El mes contable que desea seleccionar no ha sido cerrado.">
	</cfif>
</cfloop>

<!---Obtiene el ultimo mes generado--->
<cfquery name="rsUltMes" datasource="#Session.DSN#">
	Select isnull(max(Mes),0) + 1 as Mes, case isnull(max(Mes),0) + 1 when 1 then 'Enero' when 2 then 'Febrero' when 3    then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when    9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'end as MesCorrecto from    SaldosVolumen
	where Volumen_Documento = Volumen_Actual 
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
</cfquery>

<cfif form.fltMes NEQ #rsUltMes.Mes#>
	<cfthrow message="Primero debe de ejecutar el mes de #rsUltMes.MesCorrecto#">
</cfif>
				
<cfquery name="rsVolumenes" datasource="#session.dsn#">
	select Ecodigo, convert(varchar,convert(money,Volumen),1) as Volumen, Periodo, case Mes when 1 then 'Enero' when 2    then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when    8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'end    as Mes, Clas_Venta_Lin, Cod_Item, case    Clas_Venta when 'PRFC' then 'FACT' when 'PRNF' then 'NOFACT' end as    TipoVenta 
	from AnexoVolumen
	where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
</cfquery>
				
</cfoutput>		
<cfoutput>
<table>
    <tr> 
		<td width="50">&nbsp;</td>
            <td width="100000"><strong><br>Lista de productos por volumen: </br><strong/></td>
			<tr>&nbsp;</tr> 
			<td align="justify" colspan="4"  width="600" height="30">
			</tr></tr>
            </td>
	</tr> 
<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsVolumenes#"/>
			<cfinvokeargument name="cortes" value="Cod_Item"/>
			<cfinvokeargument name="desplegar" value="Periodo, Mes,Clas_Venta_Lin,TipoVenta,Volumen"/>
			<cfinvokeargument name="etiquetas" value="Periodo, Mes,Tipo Venta,Tipo Producto,Volumen"/>
			<cfinvokeargument name="formatos" value="S,I,I,S,S,I"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,N,N"/>
			<cfinvokeargument name="align" value="center,center,center,center,center,left"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="InterfazSaldosVolumen-motor.cfm"/>   
            <cfinvokeargument name="MaxRows" value="10"/>
			<cfinvokeargument name="showLink" value="false"/>
			<cfinvokeargument name="keys" value=""/>
			<cfinvokeargument name="botones" value="Aplicar,Regresar"/>
            <cfinvokeargument name="navegacion" value="#LvarNavegacion#"/>
		</cfinvoke>
</table>

<cfset session.ListaReg = #rsValores#>
<script type="text/javascript">
function funcRegresar() {
			document.lista.action = "InterfazSaldosVolumen-form.cfm";		
		}
</script>
</cfoutput>