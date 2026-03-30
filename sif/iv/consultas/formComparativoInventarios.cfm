<cfoutput>
	<cfif isdefined("url.almini")>
		<cfparam name="Form.almini" default="#url.almini#">
	</cfif>
	
	<cfif isdefined("url.almfin")>
		<cfparam name="Form.almfin" default="#url.almfin#">
	</cfif>
	
	<cfif isdefined("url.Acodigo1")>
		<cfparam name="Form.Acodigo1" default="#url.Acodigo1#">
	</cfif>
	
	<cfif isdefined("url.Acodigo2")>
		<cfparam name="Form.Acodigo2" default="#url.Acodigo2#">
	</cfif>
	
	<cfif isdefined("url.periodo")>
		<cfparam name="Form.periodo" default="#url.periodo#">
	</cfif>
	
	
	<cfif isdefined("url.mes")>
		<cfparam name="Form.mes" default="#url.mes#">
	</cfif>

</cfoutput>

<cffunction name="get_almacen" access="public" returntype="query">
	<cfargument name="aid" type="numeric" required="true" default="<!--- Código de la línea de Título --->">
	<cfquery name="rsget_almacen" datasource="#session.DSN#" >
		select rtrim(Bdescripcion) as Bdescripcion from Almacen
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#aid#">
	</cfquery>
	<cfreturn #rsget_almacen#>
</cffunction>

<cffunction name="get_articulo" access="public" returntype="query">
	<cfargument name="acodigo" type="numeric" required="true" default="<!--- Código de la línea de Título --->">
	<cfquery name="rsget_articulo" datasource="#session.DSN#" >
		select rtrim(Adescripcion) as Adescripcion from Articulos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#acodigo#">
	</cfquery>
	<cfreturn #rsget_articulo#>
</cffunction>

<cffunction name="get_mes" access="public" returntype="query">
	<cfargument name="mes" type="numeric" required="true" default="<!--- Código de la línea de Título --->">
	<cfquery name="rsget_mes" datasource="#session.DSN#" >
		select VSdesc from VSidioma
		where Iid=1 and VSgrupo=1
		and VSvalor=<cfqueryparam cfsqltype="cf_sql_char" value="#mes#">
	</cfquery>
	<cfreturn #rsget_mes#>
</cffunction>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfinvoke component="sif.Componentes.IV_SIF_IN0002" method="Kardex_Resumido_Almacen" returnvariable="rsProc">
	<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
	<cfinvokeargument name="perini" value="#form.periodo#"/>				
	<cfinvokeargument name="mesini" value="#form.mes#"/>
	<cfinvokeargument name="perfin" value="#form.periodo#"/>				
	<cfinvokeargument name="mesfin" value="#form.mes#"/>
	
	<cfif isdefined("Form.almini") and Form.almini neq "" >
		<cfinvokeargument name="almini" value="#form.almini#"/>
	</cfif>	
	<cfif isdefined("Form.almfin") and Form.almfin neq "" >
		<cfinvokeargument name="almfin" value="#form.almfin#"/>
	</cfif>	
	<cfif isdefined("Form.Acodigo1") and Form.Acodigo1 neq "" >
		<cfinvokeargument name="Acodigo1" value="#form.Acodigo1#"/>
	</cfif>	
	<cfif isdefined("Form.Acodigo2") and Form.Acodigo2 neq "" >
		<cfinvokeargument name="Acodigo2" value="#form.Acodigo2#"/>
	</cfif>		
	<cfinvokeargument name="debug" value="N"/>							
</cfinvoke>
	
<!---<cfquery name="rsProc" datasource="#session.DSN#">
	set nocount on
	exec sp_SIF_IN0002
		@Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
		,@perini =   <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.periodo#">
		,@mesini =   <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.mes#">
		,@perfin =   <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.periodo#">
		,@mesfin =   <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.mes#"> 
		<cfif isdefined("Form.almini") and Form.almini neq "" >
			,@almini =   <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.almini#">
		</cfif>	
		<cfif isdefined("Form.almfin") and Form.almfin neq "" >
			,@almfin =   <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.almfin#">
		</cfif>
		<cfif isdefined("Form.Acodigo1") and Form.Acodigo1 neq "" >
			,@Acodigo1 = <cfqueryparam cfsqltype="cf_sql_char"     value="#form.Acodigo1#">
		</cfif>	
		<cfif isdefined("Form.Acodigo2") and len(trim(Form.Acodigo2)) gt 0 >
			,@Acodigo2 = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Acodigo2#">
		</cfif>		
	set nocount off
</cfquery>
--->

<form name="form1" method="post">
<cfif isdefined("form.toExcel")>
	<cfcontent type="application/msexcel">
	<cfheader 	name="Content-Disposition" 
	value="attachment;filename=ComparativoInventarios_#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
</cfif>
<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">
    <tr> 
      <td nowrap colspan="8" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
    </tr>
    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="8" align="center"><b>Reporte de Comparativo de inventario vrs precio mercado</b></td>
    </tr>
    <tr> 
      <td colspan="8" width="50%" align="center" style="padding-right: 20px"> 
        <cfif form.almini neq "" and form.almfin neq "">
        	<b>Rango de Almac&eacute;n:</b> desde <cfoutput>#get_almacen(form.almini).Bdescripcion#</cfoutput> hasta <cfoutput>#get_almacen(form.almfin).Bdescripcion#</cfoutput> &nbsp; </td>
		</cfif>	
    </tr>

    <tr> 
      <td colspan="8" width="50%" align="center" style="padding-right: 20px"> 
        <cfoutput>
		 <b>Periodo</b> #form.periodo# &nbsp; <b>Mes </b> #get_mes(form.mes).VSdesc#</td>
        </cfoutput>
    </tr>

    <cfquery name="rsAlmacenes" dbtype="query">
    	select distinct Bdescripcion 
		from rsProc 
		order by Bdescripcion
    </cfquery>

	<!--- Total Global --->
	<cfset gtotal_saldoui    = 0 >	
	<cfset gtotal_entradas   = 0 >	
	<cfset gtotal_salidas    = 0 >	
	<cfset gtotal_saldouf    = 0 >	
	<cfset gtotal_costoi     = 0 >
	<cfset gtotal_centradas  = 0 >	
	<cfset gtotal_csalidas   = 0 >
	<cfset gtotal_costof     = 0 >	
	<cfset gtotal_PrecioMercado  = 0 >
	<cfset gtotal_CostoUnitario  = 0 >	
	<cfset gtotal_SaldoPrecioM   = 0 >
	<cfset gtotal_Diferencia     = 0 >						

    <cfloop query="rsAlmacenes">
		<!--- Total por almacen --->
		<cfset total_saldoui    = 0 >	
		<cfset total_entradas   = 0 >	
		<cfset total_salidas    = 0 >	
		<cfset total_saldouf    = 0 >	
		<cfset total_costoi     = 0 >
		<cfset total_centradas  = 0 >	
		<cfset total_csalidas   = 0 >
		<cfset total_costof     = 0 >	
		<cfset CostoUnitario    = 0 >	
		<cfset SaldoPrecioM     = 0 >					
		<cfset Diferencia       = 0 >
		
		<cfset total_PrecioMercado  = 0 >
		<cfset total_CostoUnitario  = 0 >	
		<cfset total_SaldoPrecioM   = 0 >
		<cfset total_Diferencia     = 0 >		
							
		
      <cfoutput> 
        <tr> 
          <td colspan="8" class="bottomline">&nbsp;</td>
        </tr>

        <tr> 
		  <td nowrap colspan="8" class="tituloListas"><div align="center"><font size="3">#rsAlmacenes.Bdescripcion#</font></div></td>
        </tr>

        <tr bgcolor="##006699"> 
          <td nowrap rowspan="2" align="center"><strong><font color="##FFFFFF">C&oacute;digo</font></strong></td>
          <td nowrap rowspan="2"><strong><font color="##FFFFFF">Descripci&oacute;n</font></strong></td>
          <td nowrap colspan="1" align="center"><strong><font color="##FFFFFF">Unidades</font></strong><strong></strong></td>
          <td nowrap colspan="1" align="center" bgcolor="##336699"><strong><font color="##FFFFFF">Costo</font></strong></td>
  
  	      <td nowrap rowspan="2" align="center"><strong><font color="##FFFFFF">Costo Unitario </font></strong></td>
          <td nowrap rowspan="2" align="center"><strong><font color="##FFFFFF">Precio Mercado </font></strong></td>
          <td nowrap rowspan="1" align="center"><strong><font color="##FFFFFF">Saldo</font></strong></td>
          <td nowrap rowspan="2" align="center"><strong><font color="##FFFFFF">Diferencia</font></strong></td>
  		  
        </tr>
        <tr bgcolor="##006699"> 
          <td nowrap align="center"><strong><font color="##FFFFFF">Saldo Final</font></strong></td>
          <td nowrap align="center"><strong><font color="##FFFFFF">Costo Final</font></strong></td>
          <td nowrap align="center"><strong><font color="##FFFFFF">Precio Mercado</font></strong></td>
		   
        </tr>
        <cfquery name="rsArticulos" dbtype="query">
        	select *
			from rsProc 
			where Bdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAlmacenes.Bdescripcion#">
			order by Acodigo
        </cfquery>

        <cfloop query="rsArticulos">
			  <cfset articulo = #rsArticulos.Adescripcion#>
			  <cfif #Len(rsArticulos.Adescripcion)# GT 40 >
				<cfset articulo = #Mid(rsArticulos.Adescripcion, 1, 40)# & "...">
			  </cfif>

            <tr> 
				<cfif isdefined("form.toExcel")>
					<td nowrap>#rsArticulos.Acodigo#</td>	
					<td nowrap>#articulo#</td>
				<cfelse>
					<td nowrap><a href="SQLArticulo.cfm?Aid=#rsArticulos.Aid#" title="#rsArticulos.Acodigo#">#rsArticulos.Acodigo#</a></td>	
					<td nowrap><a href="SQLArticulo.cfm?Aid=#rsArticulos.Aid#" title="#rsArticulos.Adescripcion#">#articulo#</a></td>
				</cfif>


				<td align="right" nowrap>#LSNumberFormat(rsArticulos.SaldoUnidades,',9.00' )#</td>

				<td nowrap align="right" >
					<cfif #rsArticulos.SaldoCosto# LT 0 >
						<font color="##FF0000">#LSNumberFormat( rsArticulos.SaldoCosto,',9.00' )#</font>
					<cfelse>
						#LSNumberFormat( rsArticulos.SaldoCosto,',9.00' )#
					</cfif>
				</td>
				<cfif SaldoUnidades neq 0 >
					<cfset CostoUnitario    = #rsArticulos.SaldoCosto# / #rsArticulos.SaldoUnidades# >					
				<cfelse>
					<cfset CostoUnitario    = 0 >
				</cfif>
				<td nowrap align="right" >
					<cfif CostoUnitario LT 0 >
						<font color="##FF0000">#LSNumberFormat(CostoUnitario ,',9.00' )#</font>
					<cfelse>
						#LSNumberFormat(CostoUnitario ,',9.00' )#
					</cfif>
				</td>			
				<td align="right" nowrap>#LSNumberFormat(rsArticulos.PrecioMercado,',9.00' )#</td>
				<cfset SaldoPrecioM       = #rsArticulos.PrecioMercado# * #rsArticulos.SaldoUnidades# >					
				<td align="right" nowrap>#LSNumberFormat(SaldoPrecioM,',9.00' )#</td>
				<cfset Diferencia       = #SaldoPrecioM# - #rsArticulos.SaldoCosto#>					
				<td nowrap align="right" >
					<cfif Diferencia LT 0 >
						<font color="##FF0000">#LSNumberFormat(Diferencia ,',9.00' )#</font>
					<cfelse>
						#LSNumberFormat(Diferencia ,',9.00' )#
					</cfif>
				</td>			
            </tr>
			
			<!--- Calculo de Totales por almacen --->
			<cfset total_saldouf  = #total_saldouf#  + #rsArticulos.SaldoUnidades# >
			<cfset total_costof    = #total_costof#    + #rsArticulos.SaldoCosto# >
			<cfset total_PrecioMercado  = #total_PrecioMercado# + #rsArticulos.PrecioMercado#> 
			<cfset total_CostoUnitario  = #total_CostoUnitario# + #CostoUnitario#>	
			<cfset total_SaldoPrecioM   = #total_SaldoPrecioM#  + #SaldoPrecioM#>
			<cfset total_Diferencia     = #total_Diferencia#    + #Diferencia#>		

			
			
        </cfloop>

		<!--- Pintado de Totales por almacen --->
		<tr>
			<td nowrap colspan="2" class="topline"><b>Total</b></td>
			<td nowrap align="right" class="topline"><b>#LSNumberFormat( total_saldouf, ',9.00000')#</b></td>			
			<td nowrap align="right" class="topline">
				<cfif #total_costof# LT 0 >
					<b><font color="##FF0000">#LSNumberFormat( total_costof,',9.00' )#</font></b>
				<cfelse>
					<b>#LSNumberFormat( total_costof,',9.00' )#</b>
				</cfif>
			</td>	
			
			<td nowrap align="right" class="topline">
				<cfif #total_PrecioMercado# LT 0 >
					<b><font color="##FF0000">#LSNumberFormat( total_PrecioMercado,',9.00' )#</font></b>
				<cfelse>
					<b>#LSNumberFormat( total_PrecioMercado,',9.00' )#</b>
				</cfif>
			</td>			
			<td nowrap align="right" class="topline">
				<cfif #total_CostoUnitario# LT 0 >
					<b><font color="##FF0000">#LSNumberFormat( total_CostoUnitario,',9.00' )#</font></b>
				<cfelse>
					<b>#LSNumberFormat( total_CostoUnitario,',9.00' )#</b>
				</cfif>
			</td>	
			<td nowrap align="right" class="topline">
				<cfif #total_SaldoPrecioM# LT 0 >
					<b><font color="##FF0000">#LSNumberFormat( total_SaldoPrecioM,',9.00' )#</font></b>
				<cfelse>
					<b>#LSNumberFormat( total_SaldoPrecioM,',9.00' )#</b>
				</cfif>
			</td>	
			<td nowrap align="right" class="topline">
				<cfif #total_Diferencia# LT 0 >
					<b><font color="##FF0000">#LSNumberFormat( total_Diferencia,',9.00' )#</font></b>
				<cfelse>
					<b>#LSNumberFormat( total_Diferencia,',9.00' )#</b>
				</cfif>
			</td>										

				
		</tr>
		
		<!--- Calculo global de Totales --->
		<cfset gtotal_saldouf  = #gtotal_saldouf#  + #total_saldouf# >
		<cfset gtotal_costof    = #gtotal_costof#    + #total_costof# >
		
		<cfset gtotal_PrecioMercado  = #gtotal_PrecioMercado#    + #total_PrecioMercado# >
		<cfset gtotal_CostoUnitario  = #gtotal_CostoUnitario#    + #total_CostoUnitario# >
		<cfset gtotal_SaldoPrecioM   = #gtotal_SaldoPrecioM#     + #total_SaldoPrecioM# >
		<cfset gtotal_Diferencia     = #gtotal_Diferencia#       + #total_Diferencia# >

		
      </cfoutput> 
    </cfloop>
	
	<!--- Pintado global de Totales --->
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>	
	<tr>
		<cfoutput> 
		<td colspan="2" class="topline"><b>Total General</b></td>
		<td align="right" class="topline" nowrap><b>#LSNumberFormat( gtotal_saldouf, ',9.00')#</b></td>			
		<td align="right" class="topline" nowrap >
			<cfif #gtotal_costof# LT 0 >
				<b><font color="##FF0000">#LSNumberFormat( gtotal_costof,',9.00' )#</font></b>
			<cfelse>
				<b>#LSNumberFormat( gtotal_costof,',9.00' )#</b>
			</cfif>
		</td>	
		<td align="right" class="topline" nowrap >
			<cfif #gtotal_PrecioMercado# LT 0 >
				<b><font color="##FF0000">#LSNumberFormat( gtotal_PrecioMercado,',9.00' )#</font></b>
			<cfelse>
				<b>#LSNumberFormat( gtotal_PrecioMercado,',9.00' )#</b>
			</cfif>
		</td>	
		<td align="right" class="topline" nowrap >
			<cfif #gtotal_CostoUnitario# LT 0 >
				<b><font color="##FF0000">#LSNumberFormat( gtotal_CostoUnitario,',9.00' )#</font></b>
			<cfelse>
				<b>#LSNumberFormat( gtotal_CostoUnitario,',9.00' )#</b>
			</cfif>
		</td>
		<td align="right" class="topline" nowrap >
			<cfif #gtotal_SaldoPrecioM# LT 0 >
				<b><font color="##FF0000">#LSNumberFormat( gtotal_SaldoPrecioM,',9.00' )#</font></b>
			<cfelse>
				<b>#LSNumberFormat( gtotal_SaldoPrecioM,',9.00' )#</b>
			</cfif>
		</td>				
		<td align="right" class="topline" nowrap >
			<cfif #gtotal_Diferencia# LT 0 >
				<b><font color="##FF0000">#LSNumberFormat( gtotal_Diferencia,',9.00' )#</font></b>
			<cfelse>
				<b>#LSNumberFormat( gtotal_Diferencia,',9.00' )#</b>
			</cfif>
		</td>	
		</cfoutput> 
	</tr>
	
	
    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="8" class="topline">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="8"><div align="center">------------------ Fin del Reporte 
          ------------------</div></td>
    </tr>
  </table>
</form>
