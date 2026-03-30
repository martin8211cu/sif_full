<cfif (isdefined("Session.Compras.ProcesoCompra.CMPid") and LEN(TRIM(Session.Compras.ProcesoCompra.CMPid))) and (not isdefined("form.CMPid") OR NOT Len(Trim(form.CMPid)))>
	<cfset form.CMPid = Session.Compras.ProcesoCompra.CMPid>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif NOT ISDEFINED('form.CMPid') OR NOT LEN(TRIM(form.CMPid))>
	Debe seleccionar uno de los procesos de compra o crear uno nuevo antes de continuar<br />
</cfif>
<cfquery name="qryLista" datasource="#session.dsn#">
	select 5 as opt, 
		a.ECid, a.CMPid, a.Ecodigo, a.SNcodigo, 
		a.CMCid, a.Mcodigo, a.ECtipocambio, a.ECconsecutivo, 
		a.ECnumero, a.ECnumprov, a.ECdescprov, a.ECobsprov, 
		a.ECprocesado, a.ECsubtotal, a.ECtotdesc, a.ECtotimp, 
		a.ECtotal, a.ECfechacot, a.ECestado, a.Usucodigo, 
		a.fechaalta, a.CPid, 
		'Proveedor: ' #_Cat# b.SNnumero #_Cat# ' - ' #_Cat# b.SNnombre  #_Cat# ' / Comprador: ' #_Cat# c.CMCcodigo #_Cat# ' - ' #_Cat# c.CMCnombre as ProveedorYComprador
	from ECotizacionesCM a
		inner join SNegocios b
			on b.SNcodigo = a.SNcodigo
			and b.Ecodigo = a.Ecodigo
		inner join CMCompradores c
			on c.CMCid = a.CMCid
			and c.Ecodigo = a.Ecodigo
	where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#">
		and a.ECestado = 0
	order by ProveedorYComprador, ECfechacot
</cfquery>
<cfif qryLista.RecordCount gt 0><cfset LAplicar = ",Aplicar"><cfelse><cfset LAplicar =""></cfif>


<cfquery name="rsParam2300" datasource="#session.DSN#">
    select Pvalor
    from Parametros
    where Pcodigo = 2300 <!--- Concepto A Formular: 0: Cuentas, 1:Plan de compras --->
    and Ecodigo = #session.Ecodigo#
</cfquery>
<cfset LvarBotones = "Nueva_cotizacion_del_proceso,Nueva_cotizacion_proveedor,#LAplicar#">
<cfif rsParam2300.Pvalor eq 1> <!--- Si formulan por Plan de cuentas, entonces pinta botón Verificar Garantia de Proveedores --->
	<cfset LvarBotones = "Nueva_cotizacion_del_proceso,Nueva_cotizacion_proveedor,#LAplicar#,Verificar_Garantia_de_Proveedores">
</cfif>
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="qryLista">
 	<cfinvokeargument name="query" value="#qryLista#">
	<cfinvokeargument name="cortes" value="ProveedorYComprador">
	<cfinvokeargument name="desplegar" value="ECnumprov, ECdescprov, ECprocesado, ECfechacot, ECtotal"/>
	<cfinvokeargument name="etiquetas" value="Número, Descripción, Capturado por, Fecha, Total"/>
	<cfinvokeargument name="formatos" value="V, S, S, D, M"/>
	<cfinvokeargument name="align" value="left, left, left, center, right"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="checkboxes" value="S"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="botones" value="#LvarBotones#"/>
	<cfinvokeargument name="maxrows" value="20"/>
	<cfinvokeargument name="keys" value="ECid"/>
</cfinvoke>

<br>


