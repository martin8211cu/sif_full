<script src="jquery-1.3.2.js" type="text/javascript"></script>

<script language="JavaScript" type="text/javascript">
$(document).ready(function() {
	$("div.panel_button").click(function(){
		$("div#panel").animate({
			height: "300px"
		})
		.animate({
			height: "200px"
		}, "fast");
		$("div.panel_button").toggle();
	
	});	
	
   $("div#hide_button").click(function(){
		$("div#panel").animate({
			height: "0px"
		}, "fast");
		
	
   });	
	
});
</script>

<style type="text/css">
@media print 
	{
		.noprint 
		{
			display: none;
		}
	}
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
	background-color:#FAFAFA;
}
.cssg2 {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-right-style: none;
	border-top-style: none;
	border-left-style: none;
	border-bottom-color: #CCCCCC;
	font-size:11px;
	background-color:#F5F5F5;
}
.letra {
	font-size:12px;
	padding-bottom:5px;
}
.letra2 {
	font-size:18px;
	font-weight:bold;
}
.panel_button {
	margin-left: auto;
	margin-right: auto;
	position: relative;
	top: 1px;
	left: 364px;
	width: 173px;
	height: 54px;
	background: url(/cfmx/sif/imagenes/button.png);
	border: 0px;
	z-index: 20;
	filter:alpha(opacity=70);
	-moz-opacity:0.70;
	-khtml-opacity: 0.70;
	opacity: 0.70;
	cursor: pointer;
}
.panel_button img {
	position: relative;
	top: 10px;
	border: none;
}
.panel_button a {
	text-decoration: none;
	color: #FFFFFF;
	font-size: 14px;
	font-weight: bold;
	position: relative;
	top: 5px;
	left: 10px;
	font-family: Arial, Helvetica, sans-serif;
}
.panel_button a:hover {
	color: #999999;
	text-decoration: none;
}

#toppanel {
	position: relative;
	top: -8px;
	*top: -14px;
	width: 95%;
	left: 0px;
	text-align: center;
}
#panel {
	width: 900px;
	position: relative;
	top: 1px;
	height: 0px;
	margin-left: auto;
	margin-right: auto;
	z-index: 10;
	overflow: hidden;
	text-align: left;
}
#panel_contents {
	background: black;
	filter:alpha(opacity=70);
	-moz-opacity:0.70;
	-khtml-opacity: 0.70;
	opacity: 0.70;
	height: 100%;
	width: 904px;
	position: absolute;
	z-index: -1;
}
</style>

<cfif isdefined("url.Cid2") and not isdefined("form.Cid2")>
	<cfset form.Cid2 = Url.Cid2>
</cfif>

<cfif isdefined("url.Aid") and not isdefined("form.Aid")>
	<cfset form.Aid = Url.Aid>
</cfif>

<cfif isdefined("url.Zona") and not isdefined("form.Zona")>
	<cfset form.Zona = Url.Zona>
</cfif>

<cfif isdefined("url.LPid") and not isdefined("form.LPid")>
	<cfset form.LPid = Url.LPid>
</cfif>

<cfif isdefined("url.Descuento") and not isdefined("form.Descuento")>
	<cfset form.Descuento = Url.Descuento>
</cfif>

<cfif isdefined("url.TDescuento") and not isdefined("form.TDescuento")>
	<cfset form.TDescuento = Url.TDescuento>
</cfif>

<cfif isdefined("url.VDescuento") and not isdefined("form.VDescuento")>
	<cfset form.VDescuento = Url.VDescuento>
</cfif>

<cfif isdefined("url.Recargo") and not isdefined("form.Recargo")>
	<cfset form.Recargo = Url.Recargo>
</cfif>

<cfif isdefined("url.TRecargo") and not isdefined("form.TRecargo")>
	<cfset form.TRecargo = Url.TRecargo>
</cfif>

<cfif isdefined("url.VRecargo") and not isdefined("form.VRecargo")>
	<cfset form.VRecargo = Url.VRecargo>
</cfif>

<cfif isdefined("url.fechai") and len(trim(url.fechai)) and not isdefined("form.fechai")>
	<cfset form.fechai = Url.fechai>
	<cfset vFechai = lsparseDateTime(form.fechai) >
</cfif>

<cfif isdefined("url.fechaf") and len(trim(url.fechaf)) and not isdefined("form.fechaf")>
	<cfset form.fechaf = Url.fechaf>
    <cfset vFechaf = lsparseDateTime(form.fechaf) >
</cfif>

<cfif isdefined("form.fechai") and len(trim(form.fechai)) >
	<cfset vFechai = lsparseDateTime(form.fechai) >
<cfelse>
	<cfset vFechai = createdate(1900, 01, 01) >
</cfif>

<cfif isdefined("form.fechaf")  and len(trim(form.fechaf)) >
	<cfset vFechaf = lsparseDateTime(form.fechaf) >
<cfelse>
	<cfset vFechaf = createdate(6100, 01, 01) >
</cfif>

<cfif isdefined("url.fCFid") and not isdefined("form.fCFid")>
	<cfset form.fCFid = Url.fCFid>
</cfif>

<cfif isdefined("url.CFcodigo") and not isdefined("form.CFcodigo")>
	<cfset form.CFcodigo = Url.CFcodigo>
</cfif>

<cfif isdefined("url.CFdescripcion") and not isdefined("form.CFdescripcion")>
	<cfset form.CFdescripcion = Url.CFdescripcion>
</cfif>

<!--- Rango de fechas --->
<cfif isdefined("vFechai") and isdefined("vFechaf") >
<cfif DateCompare(vFechai, vFechaf) eq 1 >
	<cfset tmp = vFechai >
    <cfset vFechai = vFfechaf >
    <cfset vFechaf = tmp >
</cfif>
</cfif>

<cfif form.Mcodigo neq -1>
    <cfquery name="Moneda" datasource="#session.DSN#">
        select Mcodigo, Miso4217
        from Monedas 
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
        and Mcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
    </cfquery>
</cfif>

<cfquery name="data0" datasource="#session.DSN#">
    select count(1) as CantidadRegistros
    from EListaPrecios el
    inner join DListaPrecios dl
    on dl.LPid = el.LPid
    and dl.Ecodigo = el.Ecodigo
    where el.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
    <cfif isdefined("form.fCFid") and len(trim(form.fCFid))>  
    	and el.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fCFid#">
    </cfif>
    
    <cfif isdefined("form.Zona") and len(trim(form.Zona)) and form.Zona neq -1>  
    	and el.id_zona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Zona#">
    </cfif>
    
    <cfif isdefined("form.LPid") and len(trim(form.LPid)) and form.LPid neq -1>
    	and el.LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LPid#">
    </cfif>
    
	<cfif isdefined("Moneda.Miso4217") and len(trim(Moneda.Miso4217))>
    	and el.moneda = <cfqueryparam cfsqltype="cf_sql_char" value="#Moneda.Miso4217#"> 
    </cfif>
    
    <cfif isdefined("form.Aid") and len(trim(form.Aid))>
    	and dl.Aid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">) 
    </cfif>
    
    <cfif isdefined("form.Cid2") and len(trim(form.Cid2))>
    	and dl.Cid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid2#">) 
    </cfif>
   
    and dl.DLfechaini >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechai#"> 
    and dl.DLfechafin <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaf#">	
</cfquery>

<cfif data0.CantidadRegistros GT 3000>
    <cf_errorCode	code = "50275"
    msg  = "Se han procesado mas de 3000 registros. La consulta regresa @errorDat_1@. Por favor sea mas especifico en los filtros seleccionados"
    errorDat_1="#data0.CantidadRegistros#"
    >
    <cfreturn>
</cfif>

<cfquery name="data" datasource="#session.DSN#">
    select 	emp.Edescripcion,
    emp.Ecodigo,
    el.LPdescripcion,
    el.LPid,
    coalesce(a.Acodigo,c.Ccodigo) as Codigo, 
    coalesce(a.Adescripcion,c.Cdescripcion) as Descripcion,
    dl.DLfechaini,
    dl.DLfechafin,
    case dl.LPtipo when 'A' then 'Articulo' else 'Servicio' end as tipo,
    cf.CFdescripcion,
    z.nombre_zona,
    m.Mnombre,
    m.Miso4217,
    dl.DLdescuento,
    dl.DLrecargo,
    dl.DLprecio,
    dl.precio_credito
    
    from EListaPrecios el	
    inner join DListaPrecios dl
    on dl.LPid = el.LPid
    and dl.Ecodigo = el.Ecodigo
    
    left outer join CFuncional cf
    on cf.CFid = el.CFid
    and cf.Ecodigo = el.Ecodigo
    
    left outer join Conceptos c
    on c.Cid = dl.Cid
    and c.Ecodigo = dl.Ecodigo
    
    left outer join Articulos a
    on a.Aid = dl.Aid
    and a.Ecodigo = dl.Ecodigo
    
    left outer join ZonaVenta z
    on z.id_zona  = el.id_zona
    and z.Ecodigo = el.Ecodigo
    
    inner join Monedas m
    on m.Miso4217 = dl.moneda        
    and m.Ecodigo = dl.Ecodigo
    
    inner join Empresas emp
    on emp.Ecodigo = el.Ecodigo 
    
    where 1=1
    
    and dl.DLfechaini >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechai#"> 
    and dl.DLfechafin <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaf#">
    <cfif isdefined("form.Cid2") and len(trim(form.Cid2)) and isdefined("form.Aid") and len(trim(form.Aid))>
    	and (dl.Cid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid2#">) or dl.Aid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">))
    <cfelseif isdefined("form.Aid") and len(trim(form.Aid))>
    	and dl.Aid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">)
    <cfelseif isdefined("form.Cid2") and len(trim(form.Cid2))>
		and dl.Cid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid2#">)
    </cfif>
    
	<cfif isdefined("form.Zona") and len(trim(form.Zona)) and form.Zona neq -1>  
    	and el.id_zona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Zona#">
    </cfif>
    
    <cfif isdefined("form.LPid") and len(trim(form.LPid)) and form.LPid neq -1>
    	and el.LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LPid#">
    </cfif>
    
	<cfif isdefined("form.fCFid") and len(trim(form.fCFid))>  
    	and el.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fCFid#">
    </cfif>
    
	<cfif isdefined("form.Descuento") and len(trim(form.Descuento))> 
     	and dl.DLdescuentoTipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TDescuento#">
    	and dl.DLdescuento     = <cfqueryparam cfsqltype="cf_sql_money" value="#form.VDescuento#"> 
    </cfif>
    
    <cfif isdefined("form.Recargo") and len(trim(form.Recargo))> 
    	and dl.DLrecargoTipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TRecargo#">
    	and dl.DLrecargo     = <cfqueryparam cfsqltype="cf_sql_money" value="#form.VRecargo#"> 
    </cfif>
    
    <cfif isdefined("Moneda.Miso4217") and len(trim(Moneda.Miso4217))>
    	and dl.moneda = <cfqueryparam cfsqltype="cf_sql_char" value="#Moneda.Miso4217#"> 
    </cfif>
    order by emp.Ecodigo, m.Miso4217, el.LPid, dl.LPtipo
</cfquery>
<div id="toppanel" class="noprint">
	<div id="panel" class="noprint">
		<div id="panel_contents" class="noprint"> 
        <form method="post" name="form1" action="ListaPrecio-form.cfm">
        <table width="96%" align="center" border="0" cellspacing="0" cellpadding="1">
        	<tr><td>&nbsp;</td></tr>
            <tr>
                <td nowrap style="color:#FFF" width="50%"><strong>Ctro. Funcional:</strong>&nbsp;</td>						
                <td nowrap style="color:#FFF" width="50%"><strong>Zona de Venta:</strong>&nbsp;</td>						
            </tr>
            <tr>
                <td nowrap class="fileLabel">
                    <cfif isdefined("Form.fCFid") and Len(Trim(Form.fCFid))>
                        <cfquery name="rscfuncional" datasource="#Session.DSN#">
                            select CFid as fCFid, CFcodigo, CFdescripcion 
                            from CFuncional where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                            and CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCFid#">
                        </cfquery>
                        <cf_rhcfuncional id="fCFid" query="#rscfuncional#">
                    <cfelse>
                        <cf_rhcfuncional id="fCFid">
                    </cfif>
                </td>
                <cfquery datasource="#Session.DSN#" name="Zona">
                    select id_zona, codigo_zona, Ecodigo, nombre_zona
                    from ZonaVenta
                    where Ecodigo = #session.Ecodigo#
                </cfquery>
                
                <td width="21%" nowrap class="fileLabel">
                    <select tabindex="1" id="Zona" name="Zona">
                        <option value="-1">-- Todas --</option>
                        <cfoutput query="Zona">
                            <option value="#Zona.id_zona#" <cfif isdefined("form.Zona") and form.Zona eq Zona.id_zona>selected</cfif>>#Zona.nombre_zona#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td nowrap style="color:#FFF"><strong>Lista Precios:</strong>&nbsp;</td>						
                <td nowrap style="color:#FFF"><strong>Moneda:</strong>&nbsp;</td>						
            </tr>
            <tr>
                <cfquery datasource="#Session.DSN#" name="ListaP">
                    select LPid, LPdescripcion
                    from EListaPrecios
                    where Ecodigo = #session.Ecodigo#
                </cfquery>
                <td nowrap class="fileLabel">
                    <select tabindex="1" id="LPid" name="LPid">
                        <option value="-1">-- Todas --</option>
                        <cfoutput query="ListaP">
                            <option value="#ListaP.LPid#" <cfif isdefined("form.LPid") and form.LPid eq ListaP.LPid>selected</cfif>>#ListaP.LPdescripcion#</option>
                        </cfoutput>
                    </select>
                </td>
                <td align="left">
                	<cf_sifmonedas  FechaSugTC="#LSDateformat(Now(),'DD/MM/YYYY')#" form="form1" tabindex="1" Todas="S">
                    <cfoutput>
						<script language="JavaScript" type="text/javascript">
                            Moneda();
                            function Moneda(){
                                <cfif isdefined("form.indice") and len(trim(form.indice))>
                                	document.form1.Mcodigo.selectedIndex  = #form.indice#;
								<cfelse>
									document.form1.Mcodigo.selectedIndex  = 0;	
								</cfif>
                            }
                        </script>
                    </cfoutput>
                </td> 
            </tr>
            <tr>
                <td nowrap style="color:#FFF"><strong>Art&iacute;culo:</strong>&nbsp;</td>						
                <td nowrap style="color:#FFF"><strong>Concepto:</strong>&nbsp;</td>						
            </tr>
            <tr>
            	<td nowrap width="1%">	
                	<cfset valuesArrayArt = ArrayNew(1)>
                    <cfif isdefined("form.Aid") and len(trim(form.Aid))>
                        <cfquery datasource="#Session.DSN#" name="rsArt">
                            select Aid,Acodigo,Adescripcion
                            from Articulos
                            where Ecodigo = #session.Ecodigo#
                            and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
                        </cfquery>
                        <cfset ArrayAppend(valuesArrayArt, rsArt.Aid)>
                        <cfset ArrayAppend(valuesArrayArt, rsArt.Acodigo)>
                        <cfset ArrayAppend(valuesArrayArt, rsArt.Adescripcion)>
                    </cfif>
                    
                    <cf_conlis
                        Campos="Aid,Acodigo,Adescripcion"
                        valuesArray="#valuesArrayArt#"
                        Desplegables="N,S,S"
                        Modificables="N,S,N"
                        Size="0,10,40"
                        tabindex="5"
                        Title="Lista de Artículos"
                        Tabla="Articulos a"
                        Columnas="a.Aid, a.Adescripcion, a.Acodigo"
                        Filtro="a.Ecodigo = #Session.Ecodigo# order by a.Acodigo"
                        Desplegar="Acodigo,Adescripcion"
                        Etiquetas="Codigo,Descripcion"
                        Formatos="S,S"
                        enterAction="Articulo"
                        fparams="Aid"
                        Align="left,left"
                        form="form1"
                        Asignar="Aid,Acodigo,Adescripcion"
                        Asignarformatos="S,S,S"											
                    /> 	
                </td>
                <td nowrap width="1%">
                   	<cfset valuesArrayCon = ArrayNew(1)>
					<cfif isdefined("form.Cid2") and len(trim(form.Cid2))>
                        <cfquery datasource="#Session.DSN#" name="rsCon">
                            select Cid,Ccodigo,Cdescripcion
                            from Conceptos
                            where Ecodigo = #session.Ecodigo#
                            and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid2#">
                        </cfquery>
                        <cfset ArrayAppend(valuesArrayCon, rsCon.Cid)>
                        <cfset ArrayAppend(valuesArrayCon, rsCon.Ccodigo)>
                        <cfset ArrayAppend(valuesArrayCon, rsCon.Cdescripcion)>
                    </cfif>								
                   	<cf_conlis
                        Campos="Cid2,Ccodigo2,Cdescripcion2"
                        valuesArray="#valuesArrayCon#"
                        Desplegables="N,S,S"
                        Modificables="N,S,N"
                        Size="0,10,40"
                        tabindex="5"
                        Title="Lista de Ingresos"
                        Tabla="Conceptos"
                        Columnas="Cid as Cid2, Ccodigo as Ccodigo2, Cdescripcion as Cdescripcion2"
                        Filtro=" Ecodigo = #Session.Ecodigo#"
                        Desplegar="Ccodigo2,Cdescripcion2"
                        Etiquetas="Codigo,Descripcion"
                        filtrar_por="Ccodigo,Cdescripcion"
                        Formatos="S,S"
                        Align="left,left"
                        form="form1"
                        Asignar="Cid2,Ccodigo2,Cdescripcion2"
                        Asignarformatos="S,S,S"											
                    /> 	 
                </td>
            </tr>
            <tr>
            	<td colspan="2" align="center"><input type="submit" value="Consultar" name="Reporte" id="Reporte" style="margin-top: 8px;  color: #111C52; background-image: url('/cfmx/sif/imagenes/forward.gif'); background-position: left center;
    background-repeat: no-repeat; padding-left: 17px; margin-bottom: 20px;" ></td>
            </tr>
        </table>
        
        </form>
        </div>
	</div>
	<div class="panel_button noprint" style="display: visible;">
    	<img src="/cfmx/sif/imagenes/Add.gif"  alt="Expandir" class="noprint"/> <a href="#">Mostrar Filtros</a> 
    </div>
	<div class="panel_button noprint" id="hide_button" style="display: none;">
    	<img src="/cfmx/sif/imagenes/Remove.gif" alt="Contraer" class="noprint"/> <a href="#">Ocultar Filtros</a> 
    </div>
</div>
<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfset Title           = "Reporte Detallado de Listas de Precios">
<cfset FileName        = "ListaPrecios">
<cfset FileName 	   = FileName & ".xls">
<cf_htmlreportsheaders title="#Title#" filename="#FileName#" download="yes" ira="repListaPrecio.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr> 
<td colspan="12" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#session.Enombre#</cfoutput></strong></td>
</tr>
<tr> 
<td colspan="12" class="letra" align="center"><b>Consulta Detallada de Listas de Precios</b></td>
</tr>
<cfoutput> 
    <tr>
    	<td colspan="12" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
    </tr>
</cfoutput> 			
</table>

<table width="98%" cellpadding="0" border="0" cellspacing="0" align="center">
<cfoutput query="data" group="Ecodigo">
    <tr><td colspan="12" >&nbsp;</td></tr>
    <tr>
        <td class="letra2" width="1%" nowrap colspan="1"><strong>Empresa:&nbsp;</strong></td>
        <td class="letra2" colspan="11"><strong>#Edescripcion#</strong></td>
    </tr>
  
	<cfoutput group="Miso4217">
        <tr>
            <td class="cssmoneda" width="1%" nowrap colspan="12">
                <strong>Moneda:&nbsp;</strong>#data.Miso4217#
            </td>
        </tr>
        <tr><td colspan="12" >&nbsp;</td></tr>
        <cfoutput group="LPid">
            <tr>
                <td class="ofice" width="1%" nowrap colspan="12">
                    <strong>Lista de Precios:&nbsp;</strong>#data.LPdescripcion#
                </td>
            </tr>
            
            <tr bgcolor="##f5f5f5" >
                <td class="cssg2" ><strong>C&oacute;digo</strong></td>
                <td class="cssg2"><strong>Descripci&oacute;n</strong></td>
                <td class="cssg2"><strong>Tipo</strong></td>
                <td class="cssg2"><strong>Fecha Inicial</strong></td>
                <td class="cssg2"><strong>Fecha Final</strong></td>
                <td class="cssg2"><strong>Centro Funcional</strong></td>
                <td class="cssg2"><strong>Zona Venta</strong></td>
                <td class="cssg2"><strong>Moneda</strong></td>
                <td class="cssg2"><strong>Descuento</strong></td>
                <td class="cssg2"><strong>Recargos</strong></td>
                <td align="right" class="cssg2"><strong>Precio Cr&eacute;dito</strong></td>
                <td align="right" class="cssg2"><strong>Precio Contado</strong></td>
            </tr>
            
			<cfoutput> 
                <tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
                    <td class="letra" >#data.Codigo#</td>
                    <td class="letra" >#data.Descripcion#</td>
                    <td class="letra" >#data.tipo#</td>
                    <td class="letra" >#LSDateFormat(data.DLfechaini,'dd/mm/yyyy')#</td>
                    <td class="letra" >#LSDateFormat(data.DLfechafin,'dd/mm/yyyy')#</td>
                    <td class="letra" >#data.CFdescripcion#</td>
                    <td class="letra" >#data.nombre_zona#</td>		
                    <td class="letra"  >#data.Mnombre#</td> 
                    <td class="letra"  >#LSCurrencyFormat(data.DLdescuento,'none')#</td>                      
                    <td class="letra"  >#LSCurrencyFormat(data.DLrecargo,'none')#</td>                      
                    <td class="letra" align="right">#LSCurrencyFormat(data.precio_credito,'none')#</td>
                    <td class="letra" align="right">#LSCurrencyFormat(data.DLprecio,'none')#</td>
                </tr>
            </cfoutput>
            <tr>
                <td colspan="12" >&nbsp;</td>
            </tr>
            
        </cfoutput> <!--- LISTA PRECIO --->
            
    </cfoutput> <!--- MONEDA --->
    
</cfoutput> <!--- EMPRESA --->

<cfif data.RecordCount gt 0 >
<tr><td colspan="12" align="center">&nbsp;</td></tr>
<tr><td colspan="12" align="center">------------------ Fin del Reporte ------------------</td></tr>
<cfelse>
<tr><td colspan="12" align="center">&nbsp;</td></tr>
<tr><td colspan="12" align="center">--- No se encontraron datos ----</td></tr>
</cfif>
</table>