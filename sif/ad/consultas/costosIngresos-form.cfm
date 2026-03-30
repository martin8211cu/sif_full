<style type="text/css">
.ofice {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-right-style: none;
	border-top-style: none;
	border-left-style: none;
	border-bottom-color: #CCCCCC;
	font-size:14px;
	background-color:#F5F5F5;
}
.cssmoneda {
	font-size:13px;
}
.cssg2 {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-right-style: none;
	border-top-style: none;
	border-left-style: none;
	border-bottom-color: #CCCCCC;
	font-size:13px;
	background-color:#F5F5F5;
}
.letra {
	font-size:13px;
	padding-bottom:5px;
}
.letra2 {
	font-size:18px;
	font-weight:bold;
}
</style>

<cfset Ecodigo = session.Ecodigo>	
<cfif isdefined("form.empresa") and len(trim(form.empresa))>
	<cfset Ecodigo = form.empresa>	
</cfif>

<cfquery name="data0" datasource="#session.DSN#">
    select count(1) as CantidadRegistros
    from (
    select c.Ctipo, c.Cid, case c.Ctipo when 'G' then 'Gastos' else 'Ingresos' end as tipoD, a.CFid, a.CFcodigo as CentroF_codigo, a.CFdescripcion as CentroF_desc, c.Ccodigo as Concepto_cod,c.Cdescripcion as Concepto_des ,c.Cporc as porcentaje_costo, coalesce(c.Cformato,c.cuentac) as objeto_gasto, b.CFCporc as porcentaje_ingreso,
        d.CFcodigo as CF_cod_Destino, d.CFdescripcion as CF_des_Destino,e.Cid as Cid_base, (select Cdescripcion from CContables where Ecodigo = #Ecodigo# and (Cformato =  coalesce(c.Cformato,c.cuentac))) as  DescripcionOb
    from CFuncional a,  CfuncionalConc b, Conceptos c, CFuncional d,CfuncionalConc e
    where a.CFid = b.CFid
        and b.Cid = c.Cid
        and b.CFidD *= d.CFid
        and b.CFCid_Costo *= e.CFCid
        and a.Ecodigo = b.Ecodigo
        and a.Ecodigo = c.Ecodigo
        and a.Ecodigo = #Ecodigo#) a, Conceptos b
    where 
    a.Cid_base *= b.Cid
    and b.Ecodigo = #Ecodigo#
    <cfif isdefined("form.fCFid") and len(trim(form.fCFid))>
    	and a.CFid =  #form.fCFid#
    </cfif>
    <cfif isdefined("form.Cid") and form.Cid gt 0 and isdefined("form.Cid2") and form.Cid2 gt 0>
    	and (a.Cid = #form.Cid# or a.Cid = #form.Cid2#)
    <cfelseif isdefined("form.Cid") and form.Cid gt 0>
    	and a.Cid = #form.Cid#
    <cfelseif isdefined("form.Cid2") and form.Cid2 gt 0>    
    	and a.Cid = #form.Cid2#
    </cfif>
    <cfif isdefined("form.IngPorc") and form.IngPorc gt 0>
    	and a.porcentaje_ingreso = <cfqueryparam cfsqltype="cf_sql_double" value="#form.IngPorc#">
    </cfif>
    
</cfquery>

<cfif data0.CantidadRegistros GT 3000>
    <cf_errorCode	code = "50275"
    msg  = "Se han procesado mas de 3000 registros. La consulta regresa @errorDat_1@. Por favor sea mas especifico en los filtros seleccionados"
    errorDat_1="#data0.CantidadRegistros#"
    >
    <cfreturn>
</cfif>

<cfquery name="data" datasource="#session.DSN#">
    SELECT a.*, b.Ccodigo as costo_cod_base, b.Cdescripcion as costo_des_base
    from (
    select c.Ctipo, c.Cid, case c.Ctipo when 'G' then 'Gastos' else 'Ingresos' end as tipoD, a.CFid, a.CFcodigo as CentroF_codigo, a.CFdescripcion as CentroF_desc, c.Ccodigo as Concepto_cod,c.Cdescripcion as Concepto_des ,c.Cporc as porcentaje_costo, coalesce(c.Cformato,c.cuentac) as objeto_gasto, b.CFCporc as porcentaje_ingreso,
        d.CFcodigo as CF_cod_Destino, d.CFdescripcion as CF_des_Destino,e.Cid as Cid_base, (select Cdescripcion from CContables where Ecodigo = #Ecodigo# and (Cformato =  coalesce(c.Cformato,c.cuentac))) as  DescripcionOb
    from CFuncional a,  CfuncionalConc b, Conceptos c, CFuncional d,CfuncionalConc e
    where a.CFid = b.CFid
        and b.Cid = c.Cid
        and b.CFidD *= d.CFid
        and b.CFCid_Costo *= e.CFCid
        and a.Ecodigo = b.Ecodigo
        and a.Ecodigo = c.Ecodigo
        and a.Ecodigo = #Ecodigo#) a, Conceptos b
    where 
    a.Cid_base *= b.Cid
    and b.Ecodigo = #Ecodigo#
    <cfif isdefined("form.fCFid") and len(trim(form.fCFid))>
    	and a.CFid =  #form.fCFid#
    </cfif>
    <cfif isdefined("form.Cid") and form.Cid gt 0 and isdefined("form.Cid2") and form.Cid2 gt 0>
    	and (a.Cid = #form.Cid# or a.Cid = #form.Cid2#)
    <cfelseif isdefined("form.Cid") and form.Cid gt 0>
    	and a.Cid = #form.Cid#
    <cfelseif isdefined("form.Cid2") and form.Cid2 gt 0>    
    	and a.Cid = #form.Cid2#
    </cfif>
    <cfif isdefined("form.IngPorc") and form.IngPorc gt 0>
    	and a.porcentaje_ingreso = <cfqueryparam cfsqltype="cf_sql_double" value="#form.IngPorc#">
    </cfif>
    order by a.CentroF_desc, a.Ctipo, a.Concepto_des
</cfquery>

<cfquery name="rsEmpresa" datasource="#session.dsn#">
    select Ecodigo, Edescripcion as Enombre
    from Empresas
    where Ecodigo = #Ecodigo#
    order by Enombre
</cfquery>
    
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr> 
<td colspan="6" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#rsEmpresa.Enombre#</cfoutput></strong></td>
</tr>
<tr> 
<td colspan="6" class="letra" align="center"><b>Consulta Detallada de Listas de Precios</b></td>
</tr>
<cfoutput> 
    <tr>
    	<td colspan="6" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
    </tr>
</cfoutput> 			
</table>

<table width="98%" cellpadding="0" border="0" cellspacing="0" align="center">
<cfoutput query="data" group="CentroF_desc">
    <tr><td colspan="6" >&nbsp;</td></tr>
    <tr>
        <td class="letra2" bgcolor="##CCCCCC" style="padding:4px;" width="1%" nowrap colspan="1"><strong>Centro Funcional:&nbsp;</strong></td>
        <td class="letra2" bgcolor="##CCCCCC" style="padding:4px;" colspan="5">#data.CentroF_desc#</td>
    </tr>
  
	<cfoutput group="Ctipo">
        <tr>
            <td class="cssmoneda" bgcolor="##e5e5e5" width="1%" nowrap colspan="6">
                <strong>Conceptos de:&nbsp;</strong>#data.tipoD#
            </td>
        </tr>
        <cfoutput group="Concepto_des">
            <cfif data.Ctipo eq 'G'>
                <tr bgcolor="##f5f5f5" >
                	<td class="cssg2" ><strong>C&oacute;digo</strong></td>
                    <td class="cssg2" colspan="2"><strong>Descripci&oacute;n del Costo</strong></td>
                    <td class="cssg2"><strong>Porcentaje Costo</strong></td>
                    <td class="cssg2" colspan="2"><strong>Objeto de Gasto</strong></td>
                </tr>
                <cfoutput> 
                    <tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
                        <td class="letra" >#data.Concepto_cod#</td>
                        <td class="letra" colspan="2">#data.Concepto_des#</td>
                        <td class="letra" >#data.porcentaje_costo#</td>
                        <td class="letra" colspan="2"><cfif len(trim(data.DescripcionOb))>#data.DescripcionOb#<cfelse>No Definido</cfif></td>
                    </tr>
	            </cfoutput>
            <cfelse>
            	<tr bgcolor="##f5f5f5" >
                	<td class="cssg2" ><strong>C&oacute;digo</strong></td>
                    <td class="cssg2"><strong>Descripci&oacute;n del Costo</strong></td>
                    <td class="cssg2"><strong>Porcentaje Ingreso</strong></td>
                    <td class="cssg2"><strong>Objeto de Gasto</strong></td>
                    <td class="cssg2"><strong>Centro Funcional Destino</strong></td>
                    <td class="cssg2"><strong>Costo Base</strong></td>
                </tr>
                <cfoutput> 
                    <tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
                        <td class="letra" >#data.Concepto_cod#</td>
                        <td class="letra" >#data.Concepto_des#</td>
                        <td class="letra" >#data.porcentaje_ingreso#</td>
                        <td class="letra" ><cfif len(trim(data.DescripcionOb))>#data.DescripcionOb#<cfelse>No Definido</cfif></td>
                        <td class="letra" ><cfif len(trim(data.CF_des_Destino))>#data.CF_des_Destino#<cfelse>No Definido</cfif></td>
                        <td class="letra" ><cfif len(trim(data.costo_des_base))>#data.costo_des_base#<cfelse>Porcentaje con Respecto al Total</cfif></td>
                    </tr>
	            </cfoutput>
            </cfif>
			
            <tr>
                <td colspan="6" >&nbsp;</td>
            </tr>
            
        </cfoutput> <!--- LISTA PRECIO --->
            
    </cfoutput> <!--- MONEDA --->
    
</cfoutput> <!--- EMPRESA --->

<cfif data.RecordCount gt 0 >
<tr><td colspan="6" align="center">&nbsp;</td></tr>
<tr><td colspan="6" align="center">------------------ Fin del Reporte ------------------</td></tr>
<cfelse>
<tr><td colspan="6" align="center">&nbsp;</td></tr>
<tr><td colspan="6" align="center">--- No se encontraron datos ----</td></tr>
</cfif>
</table>