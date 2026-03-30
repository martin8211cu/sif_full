<cfquery name="rsReporte" datasource="#session.dsn#">
	select  art.Acodigo CodigoArticulo, art.Adescripcion Articulo, alm.Almcodigo CodigoAlmacen, alm.Bdescripcion Almacen,
    	cl.Ccodigoclas CodigoClasificacion, cl.Cdescripcion Clasificacion,cl.cuentac ObjetoGasto,
		iac.IACcodigogrupo CodigoGrupoCuentas, iac.IACdescripcion GrupoCuentas,
        cf0.CFformato CuentaInventario,
        cf1.CFformato CuentaIngresoAjuste,
        cf2.CFformato CuentaGatoAjuste,
        cf3.CFformato CuentaCompras,
        cf4.CFformato CuentaIngresoVentas,
        cf5.CFformato CuentaCostoVentas,
        cf6.CFformato CuentaDescuentoventas,
        cf7.CFformato CuentaTransito
    from Existencias ext
        inner join Articulos art 
        	on art.Aid = ext.Aid
        inner join Almacen alm 
        	on alm.Aid = ext.Alm_Aid
        left outer join Clasificaciones cl on 
        	cl.Ecodigo = art.Ecodigo and cl.Ccodigo = art.Ccodigo
        left outer join IAContables iac 
        	on iac.Ecodigo = ext.Ecodigo and iac.IACcodigo = ext.IACcodigo
        left outer join CFinanciera cf0 
        	on cf0.Ccuenta = iac.IACinventario
        left outer join CFinanciera cf1 
       		on cf1.Ccuenta = iac.IACingajuste
        left outer join CFinanciera cf2 
        	on cf2.Ccuenta = iac.IACgastoajuste
        left outer join CFinanciera cf3 
        	on cf3.Ccuenta = iac.IACcompra
        left outer join CFinanciera cf4 
        	on cf4.Ccuenta = iac.IACingventa
        left outer join CFinanciera cf5 
        	on cf5.Ccuenta = iac.IACcostoventa
        left outer join CFinanciera cf6 
        	on cf6.Ccuenta = iac.IACdescventa
        left outer join CFinanciera cf7 
        	on cf7.Ccuenta = iac.IACtransito
	where ext.Ecodigo = #session.Ecodigo#
	<cfif isdefined('form.AcodigoI') and len(trim(form.AcodigoI))>
    	and rtrim(Acodigo) >= <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.AcodigoI)#">
    </cfif>
    <cfif isdefined('form.AcodigoF') and len(trim(form.AcodigoF))>
    	and rtrim(Acodigo) <= <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.AcodigoF)#">
    </cfif>
	order by alm.Almcodigo, alm.Bdescripcion, art.Acodigo, art.Adescripcion
</cfquery>

<cfif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 1>
	<cfset formatos = "flashpaper">
<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 2>
    <cfset formatos = "pdf">
<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 3>
    <cfset formatos = "excel">
</cfif>
<cfif formatos eq "excel">
     <cf_QueryToFile query="#rsReporte#" FILENAME="CuentasInventario.xls" titulo="Cuentas de Inventario">
<cfelse>
	<cfthrow message="No implementado">
</cfif>