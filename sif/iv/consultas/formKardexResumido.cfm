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
	
	<cfif isdefined("url.perini")>
		<cfparam name="Form.perini" default="#url.perini#">
	</cfif>
	
	<cfif isdefined("url.perfin")>
		<cfparam name="Form.perfin" default="#url.perfin#">
	</cfif>
	
	<cfif isdefined("url.mesini")>
		<cfparam name="Form.mesini" default="#url.mesini#">
	</cfif>
	
	<cfif isdefined("url.mesfin")>
		<cfparam name="Form.mesfin" default="#url.mesfin#">
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
	<cfinvokeargument name="perini" value="#form.perini#"/>				
	<cfinvokeargument name="mesini" value="#form.mesini#"/>
	<cfinvokeargument name="perfin" value="#form.perfin#"/>				
	<cfinvokeargument name="mesfin" value="#form.mesfin#"/>
	
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
	<cfif isdefined("Form.Ccodigo") and Form.Ccodigo neq "" >
		<cfinvokeargument name="Ccodigo" value="#form.Ccodigo#"/>
	</cfif>		
	<cfif isdefined("Form.CcodigoF") and Form.CcodigoF neq "" >
		<cfinvokeargument name="CcodigoF" value="#form.CcodigoF#"/>
	</cfif>		
	<cfinvokeargument name="debug" value="N"/>							
</cfinvoke>
	

<!---<cfquery name="rsProc" datasource="#session.DSN#">
	exec sp_SIF_IN0002
		@Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
		,@perini =   <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.perini#">
		,@mesini =   <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.mesini#">
		,@perfin =   <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.perfin#">
		,@mesfin =   <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.mesfin#"> 
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
</cfquery>--->


<form name="form1" method="post">
<cfif isdefined("form.toExcel")>
	<cfcontent type="application/msexcel">
	<cfheader 	name="Content-Disposition" 
	value="attachment;filename=KardexResumido_#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
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
<cfflush interval="32">
  <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">
    <tr> 
      <td nowrap colspan="13" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
    </tr>
    <tr> 
      <td colspan="13">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="13" align="center"><b>Reporte de Kardex Resumido</b></td>
    </tr>
    <tr> 
      <td colspan="13" width="50%" align="center" style="padding-right: 20px"> 
        <cfif form.almini neq "" and form.almfin neq "">
        	<b>Rango de Almac&eacute;n:</b> desde <cfoutput>#get_almacen(form.almini).Bdescripcion#</cfoutput> hasta <cfoutput>#get_almacen(form.almfin).Bdescripcion#</cfoutput> &nbsp; </td>
		</cfif>	
    </tr>

    <tr> 
      <td colspan="13" width="50%" align="center" style="padding-right: 20px"> 
        <cfoutput>
		<b>Desde </b> #get_mes(form.mesini).VSdesc#-#form.perini# <b>Hasta</b> #get_mes(form.mesfin).VSdesc#-#form.perfin# &nbsp; </td>
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
		
      <cfoutput> 
        <tr> 
          <td colspan="13" class="bottomline">&nbsp;</td>
        </tr>

        <tr> 
		  <td nowrap colspan="13" class="tituloListas"><div align="center"><font size="3">#rsAlmacenes.Bdescripcion#</font></div></td>
        </tr>

        <tr bgcolor="##006699"> 
          <td nowrap rowspan="2" align="center"><strong><font color="##FFFFFF">C&oacute;digo</font></strong></td>
          <td nowrap rowspan="2"><strong><font color="##FFFFFF">Descripci&oacute;n</font></strong></td>
          <td nowrap colspan="2" align="center"><strong><font color="##FFFFFF">Ubicaci&oacute;n</font></strong></td>
          <td nowrap colspan="4" align="center"><strong><font color="##FFFFFF">Unidades</font></strong><strong></strong></td>
          <td nowrap colspan="4" align="center" bgcolor="##336699"><strong><font color="##FFFFFF">Costo</font></strong></td>
        </tr>
        <tr bgcolor="##006699">
          <td nowrap align="center"><strong><font color="##FFFFFF">Estante</font></strong></td>
          <td nowrap align="center"><strong><font color="##FFFFFF">Casilla</font></strong></td>
          <td nowrap align="center"><strong><font color="##FFFFFF">Saldo Inicial</font></strong></td>		
          <td nowrap align="center"><strong><font color="##FFFFFF">Entradas</font></strong></td>
          <td nowrap align="center"><strong><font color="##FFFFFF">Salidas</font></strong></td>
          <td nowrap align="center"><strong><font color="##FFFFFF">Saldo Final</font></strong></td>
          <td nowrap align="center"><strong><font color="##FFFFFF">Costo Inicial</font></strong></td>
          <td nowrap align="center"><strong><font color="##FFFFFF">Entradas</font></strong></td>
          <td nowrap align="center"><strong><font color="##FFFFFF">Salidas</font></strong></td>
          <td nowrap align="center"><strong><font color="##FFFFFF">Costo Final</font></strong></td>
        </tr>
        <cfquery name="rsArticulos" dbtype="query">
        	select *
			from rsProc 
			where Bdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAlmacenes.Bdescripcion#">
            <cfif isdefined("form.sinMovimientos")>
            	and Entradas not in(0) or Salidas not in(0)
            </cfif>
			order by Acodigo
        </cfquery>

        <cfloop query="rsArticulos">
			  <cfset articulo = #rsArticulos.Adescripcion#>
			  <cfif #Len(rsArticulos.Adescripcion)# GT 40 >
				<cfset articulo = #Mid(rsArticulos.Adescripcion, 1, 40)# & "...">
			  </cfif>

            <tr> 
                <cfif isdefined("form.toExcel")>
                    <td nowrap>&nbsp;#rsArticulos.Acodigo#</td>	
                    <td nowrap>#articulo#</td>
                <cfelse>
                    <cfset LvarParametros= '&almini=#Form.almini#&almfin=#Form.almfin#&Acodigo1=#Form.Acodigo1#&Acodigo2=#Form.Acodigo2#&perini=#Form.perini#&perfin=#Form.perfin#&mesini=#Form.mesini#&mesfin=#Form.mesfin#'>

                    <td nowrap>&nbsp;<a href="SQLArticulo.cfm?Aid=#rsArticulos.Aid##LvarParametros#" title="#rsArticulos.Acodigo#">#rsArticulos.Acodigo#</a></td>	
                    <td nowrap><a href="SQLArticulo.cfm?Aid=#rsArticulos.Aid##LvarParametros#" title="#rsArticulos.Adescripcion#">#articulo#</a></td>
                </cfif>
				<td nowrap align="center">#rsArticulos.Eestante#</td>
				<td nowrap align="center">#rsArticulos.Ecasilla#</td>
				<td nowrap align="right">#LSNumberFormat( rsArticulos.SaldoInicialU, ',9.00000')#</td>
				<td nowrap align="right">#LSNumberFormat( rsArticulos.Entradas, ',9.00000')#</td>
				<td align="right" nowrap>#LSNumberFormat( rsArticulos.Salidas, ',9.00000')#</td>
				<td align="right" nowrap>#LSNumberFormat(rsArticulos.SaldoUnidades,',9.00000' )#</td>

				<td align="right" nowrap>
					<cfif #rsArticulos.SaldoCostoC# LT 0 >
						<font color="##FF0000">#LSNumberFormat( rsArticulos.SaldoCostoC,',9.00000' )#</font>
					<cfelse>
						#LSNumberFormat( rsArticulos.SaldoCostoC,',9.00000' )#
					</cfif>
				</td>			

				<td align="right" nowrap >
					<cfif #rsArticulos.CEntradas# LT 0 >
						<font color="##FF0000">#LSNumberFormat( rsArticulos.CEntradas,',9.00000' )#</font>
					<cfelse>
						#LSNumberFormat( rsArticulos.CEntradas,',9.00000' )#
					</cfif>
				</td>			

				<td nowrap align="right" >
					<cfif #rsArticulos.CSalidas# LT 0 >
						<font color="##FF0000">#LSNumberFormat( rsArticulos.CSalidas,',9.00000' )#</font>
					<cfelse>
						#LSNumberFormat( rsArticulos.CSalidas,',9.00000' )#
					</cfif>
				</td>			
				
				<td nowrap align="right" >
					<cfif #rsArticulos.SaldoCosto# LT 0 >
						<font color="##FF0000">#LSNumberFormat( rsArticulos.SaldoCosto,',9.00000' )#</font>
					<cfelse>
						#LSNumberFormat( rsArticulos.SaldoCosto,',9.00000' )#
					</cfif>
				</td>			
				
				
            </tr>
			
			<!--- Calculo de Totales por almacen --->
			<cfset total_saldoui  = #total_saldoui#  + #rsArticulos.SaldoInicialU# >	
			<cfset total_entradas = #total_entradas# + #rsArticulos.Entradas# >
			<cfset total_salidas  = #total_salidas#  + #rsArticulos.Salidas# >
			<cfset total_saldouf  = #total_saldouf#  + #rsArticulos.SaldoUnidades# >
			
			<cfset total_costoi    = #total_costoi#    + #rsArticulos.SaldoCostoC# >
			<cfset total_centradas = #total_centradas# + #rsArticulos.CEntradas# >
			<cfset total_csalidas  = #total_csalidas#  + #rsArticulos.CSalidas# >
			<cfset total_costof    = #total_costof#    + #rsArticulos.SaldoCosto# >
			
        </cfloop>

		<!--- Pintado de Totales por almacen --->
		<tr>
			<td nowrap colspan="4" class="topline"><b>Total</b></td>
			<td nowrap align="right" class="topline"><b>#LSNumberFormat( total_saldoui, ',9.00000')#</b></td>
			<td nowrap align="right" class="topline"><b>#LSNumberFormat( total_entradas, ',9.00000')#</b></td>
			<td nowrap align="right" class="topline"><b>#LSNumberFormat( total_salidas, ',9.00000')#</b></td>
			<td nowrap align="right" class="topline"><b>#LSNumberFormat( total_saldouf, ',9.00000')#</b></td>			

			<td align="right" class="topline" nowrap>
				<cfif #total_costoi# LT 0 >
					<b><font color="##FF0000">#LSNumberFormat( total_costoi,',9.00000' )#</font></b>
				<cfelse>
					<b>#LSNumberFormat( total_costoi,',9.00000' )#</b>
				</cfif>
			</td>			
			
			<td nowrap align="right" class="topline">
				<cfif #total_centradas# LT 0 >
					<b><font color="##FF0000">#LSNumberFormat( total_centradas,',9.00000' )#</font></b>
				<cfelse>
					<b>#LSNumberFormat( total_centradas,',9.00000' )#</b>
				</cfif>
			</td>			

			<td align="right" class="topline" nowrap>
				<cfif #total_csalidas# LT 0 >
					<b><font color="##FF0000">#LSNumberFormat( total_csalidas,',9.00000' )#</font></b>
				<cfelse>
					<b>#LSNumberFormat( total_csalidas,',9.00000' )#</b>
				</cfif>
			</td>			

			<td nowrap align="right" class="topline">
				<cfif #total_costof# LT 0 >
					<b><font color="##FF0000">#LSNumberFormat( total_costof,',9.00000' )#</font></b>
				<cfelse>
					<b>#LSNumberFormat( total_costof,',9.00000' )#</b>
				</cfif>
			</td>			
		</tr>
		
		<!--- Calculo global de Totales --->
		<cfset gtotal_saldoui  = #gtotal_saldoui#  + #total_saldoui# >
		<cfset gtotal_entradas = #gtotal_entradas# + #total_entradas# >
		<cfset gtotal_salidas  = #gtotal_salidas#  + #total_salidas# >
		<cfset gtotal_saldouf  = #gtotal_saldouf#  + #total_saldouf# >
		
		<cfset gtotal_costoi    = #gtotal_costoi#    + #total_costoi# >
		<cfset gtotal_centradas = #gtotal_centradas# + #total_centradas# >
		<cfset gtotal_csalidas  = #gtotal_csalidas#  + #total_csalidas# >
		<cfset gtotal_costof    = #gtotal_costof#    + #total_costof# >
		
      </cfoutput> 
    </cfloop>
	
	<!--- Pintado global de Totales --->
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>	
	<tr>
		<cfoutput> 
		<td colspan="4" class="topline"><b>Total General</b></td>
		<td nowrap align="right" class="topline"><b>#LSNumberFormat( gtotal_saldoui, ',9.00000')#</b></td>
		<td nowrap align="right" class="topline"><b>#LSNumberFormat( gtotal_entradas, ',9.00000')#</b></td>
		<td nowrap align="right" class="topline"><b>#LSNumberFormat( gtotal_salidas, ',9.00000')#</b></td>
		<td align="right" class="topline" nowrap><b>#LSNumberFormat( gtotal_saldouf, ',9.00000')#</b></td>			

		<td align="right" class="topline" nowrap>
			<cfif #gtotal_costoi# LT 0 >
				<b><font color="##FF0000">#LSNumberFormat( gtotal_costoi,',9.00000' )#</font></b>
			<cfelse>
				<b>#LSNumberFormat( gtotal_costoi,',9.00000' )#</b>
			</cfif>
		</td>			
		
		<td nowrap align="right" class="topline">
			<cfif #gtotal_centradas# LT 0 >
				<b><font color="##FF0000">#LSNumberFormat( gtotal_centradas,',9.00000' )#</font></b>
			<cfelse>
				<b>#LSNumberFormat( gtotal_centradas,',9.00000' )#</b>
			</cfif>
		</td>			

		<td nowrap align="right" class="topline">
			<cfif #gtotal_csalidas# LT 0 >
				<b><font color="##FF0000">#LSNumberFormat( gtotal_csalidas,',9.00000' )#</font></b>
			<cfelse>
				<b>#LSNumberFormat( gtotal_csalidas,',9.00000' )#</b>
			</cfif>
		</td>			

		<td align="right" class="topline" nowrap >
			<cfif #gtotal_costof# LT 0 >
				<b><font color="##FF0000">#LSNumberFormat( gtotal_costof,',9.00000' )#</font></b>
			<cfelse>
				<b>#LSNumberFormat( gtotal_costof,',9.00000' )#</b>
			</cfif>
		</td>			
		
		</cfoutput> 
	</tr>
	
	
    <tr> 
      <td colspan="13">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="13" class="topline">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="13">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="13"><div align="center">------------------ Fin del Reporte 
          ------------------</div></td>
    </tr>
  </table>
</form>
