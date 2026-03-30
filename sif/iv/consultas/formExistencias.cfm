<!---►►Estilos◄◄--->
<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 2px;
		padding-bottom: 2px;
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
</style>           
 
<!---►►Inicializacion de Variables◄◄---> 
<cf_navegacion name="almaceni">
<cf_navegacion name="almacenf">
<cf_navegacion name="articuloi">
<cf_navegacion name="articulof">
<cf_navegacion name="clasificacioni">
<cf_navegacion name="clasificacionf">

<!---►►Obtencion de los Datos◄◄--->
<cffunction name="get_almacen" access="public" returntype="query">
	<cfargument name="aid" type="numeric" required="true" default="<!--- Código de la línea de Título --->">
	<cfquery name="rsget_almacen" datasource="#session.DSN#" >
		select rtrim(Bdescripcion) as Bdescripcion from Almacen
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Aid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#aid#">
	</cfquery>
	<cfreturn rsget_almacen>
</cffunction>

<cffunction name="get_articulo" access="public" returntype="query">
	<cfargument name="acodigo" type="numeric" required="true" default="<!--- Código de la línea de Título --->">
	<cfquery name="rsget_articulo" datasource="#session.DSN#" >
		select rtrim(Adescripcion) as Adescripcion from Articulos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#acodigo#">
	</cfquery>
	<cfreturn rsget_articulo>
</cffunction>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfinvoke component="sif.Componentes.IV_SIF_IN0001" method="Existencias_por_Almacen" returnvariable="rsProc">
	<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
	<cfif isdefined("Form.almaceni") and Form.almaceni neq "" >
		<cfinvokeargument name="almaceni" value="#form.almaceni#"/>
	</cfif>	
	<cfif isdefined("Form.almacenf") and Form.almacenf neq "" >
		<cfinvokeargument name="almacenf" value="#form.almacenf#"/>
	</cfif>	
	<cfif isdefined("Form.articuloi") and Form.articuloi neq "" >
		<cfinvokeargument name="articuloi" value="#form.articuloi#"/>
	</cfif>	
	<cfif isdefined("Form.articulof") and Form.articulof neq "" >
		<cfinvokeargument name="articulof" value="#form.articulof#"/>
	</cfif>		
	<cfif isdefined("Form.clasificacioni") and Form.clasificacioni neq "" >
		<cfinvokeargument name="clasificacioni" value="#form.clasificacioni#"/>
	</cfif>	
	<cfif isdefined("Form.clasificacionf") and Form.clasificacionf neq "" >
		<cfinvokeargument name="clasificacionf" value="#form.clasificacionf#"/>
	</cfif>	
	<cfinvokeargument name="debug" value="N"/>							
</cfinvoke>
<cfset where = ''>
<cfif not isdefined("form.chkExistcero") and not isdefined("form.chkExistneg")>
	<cfset where = " Eexistencia > 0 " >
<cfelseif isdefined("form.chkExistcero")>
	<cfset where = " Eexistencia >= 0  ">
<cfelseif isdefined("form.chkExistneg")>
	<cfset where = " Eexistencia != 0 " >
</cfif>

<cfquery name="rsAlmacenes" dbtype="query">
	select distinct Bdescripcion 
	from rsProc 
	<cfif len(trim(where))>
		where #where#
	</cfif>
	order by Bdescripcion
</cfquery>

<!---►►Pintado del Reporte◄◄--->
<form name="form1" method="post">
	<cfif isdefined("form.toExcel")>
        <cfcontent type="application/msexcel">
        <cfheader 	name="Content-Disposition" 
        value="attachment;filename=ArticulosInventario_#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
    </cfif>
  	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">
    	<tr><td colspan="9" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td></tr>
    	<tr><td colspan="76">&nbsp;</td></tr>
    	<tr><td colspan="9" align="center"><b>Reporte de Existencias de Inventario</b></td></tr>
    	<tr> 
	  		<cfoutput>
		 	 <td colspan="9" align="center"><b>Fecha del Reporte:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
	  		</cfoutput> 
    	</tr>
        <tr> 
          	<td colspan="9" width="50%" align="center" style="padding-right: 20px"> 
				<cfif form.almaceni neq "" and form.almacenf neq "">
                    <b>Rango de Almac&eacute;n:</b> desde <cfoutput>#get_almacen(form.almaceni).Bdescripcion#</cfoutput> hasta <cfoutput>#get_almacen(form.almacenf).Bdescripcion#</cfoutput> &nbsp; 
                </cfif>
        	</td>
        </tr>
	
		<cfif rsAlmacenes.RecordCount gt 0>
			<!--- Total Global --->
			<cfset gtotal_costo      = 0 >	
		
			<cfloop query="rsAlmacenes">
				<!--- Total por almacen --->
				<cfset total_costo      = 0 >	
				
			  <cfoutput> 
				<tr> 
				  <td colspan="9" class="bottomline">&nbsp;</td>
				</tr>
		
				<tr> 
				  <td colspan="9" class="tituloListas"><div align="center"><font size="3">#rsAlmacenes.Bdescripcion#</font></div></td>
				</tr>
				<!---►►Titulos de los Encabezados◄◄--->
				<tr class="encabReporte"> 
					<td align="left"><strong>Código</strong></td>
					<td align="left" ><strong>Descripción</strong></td>
                    <td align="left" ><strong>Estante</strong></td>
                    <td align="left" ><strong>Casilla</strong></td>
					<td align="right"><strong>Existencia</strong></td>
                    <td align="right"><strong>Requis.Pendientes</strong></td>
                    <td align="right"><strong>Devol.Pendientes</strong></td>
					<td align="right"><strong>Costo Unitario</strong></td>		
					<td align="right"><strong>Costo Total</strong></td>
				</tr>
		
				<cfquery name="rsArticulos" dbtype="query">
					select *
					from rsProc 
					where Bdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#rsAlmacenes.Bdescripcion#">
					<cfif len(trim(where))>
						and	#where#
					</cfif>
					order by Acodigo
				</cfquery>
		
				<cfloop query="rsArticulos">
					  <cfset articulo = #rsArticulos.Adescripcion#>
					  <cfif #Len(rsArticulos.Adescripcion)# GT 40 >
						<cfset articulo = #Mid(rsArticulos.Adescripcion, 1, 40)# & "...">
					  </cfif>
		
					<tr> 
                        <td><cfif isdefined("form.toExcel")>&nbsp;#rsArticulos.Acodigo#<cfelse><a href="SQLArticulo.cfm?Aid=#rsArticulos.Aid#" title="#rsArticulos.Aid#">#rsArticulos.Acodigo#</a></cfif></td>	
                        <td><cfif isdefined("form.toExcel")>#articulo#<cfelse><a href="SQLArticulo.cfm?Aid=#rsArticulos.Aid#" title="#rsArticulos.Adescripcion#">#articulo#</a></cfif></td>
						<td>&nbsp;#rsArticulos.Eestante#</td>
                        <td>&nbsp;#rsArticulos.Ecasilla#</td>
						<td align="right">#LSNumberFormat( rsArticulos.Eexistencia, ',9.00')#</td>
                        <td align="right">#LSNumberFormat( rsArticulos.reqPedientes, ',9.00')#</td>
                        <td align="right">#LSNumberFormat( rsArticulos.DebPedientes, ',9.00')#</td>
						<td align="right" nowrap>#LSNumberFormat( rsArticulos.Ecostou,',9.00' )#</td>			
		
						<td align="right" nowrap >
							<cfif #rsArticulos.Ecostototal# LT 0 >
								<font color="##FF0000">#LSNumberFormat( rsArticulos.Ecostototal,',9.00' )#</font>
							<cfelse>
								#LSNumberFormat( rsArticulos.Ecostototal,',9.00' )#
							</cfif>
						</td>			
					</tr>
					
					<!--- Calculo de Totales por almacen --->
					<cfset total_costo      = #total_costo#      + #rsArticulos.Ecostototal# >
		
				</cfloop>
		
				<!--- Pintado de Totales por almacen --->
				<tr>
					<td colspan="8" class="topline"><b>Total</b></td>
		
					<td align="right" class="topline" nowrap>
						<cfif #total_costo# LT 0 >
							<b><font color="##FF0000">#LSNumberFormat( total_costo,',9.00' )#</font></b>
						<cfelse>
							<b>#LSNumberFormat( total_costo,',9.00' )#</b>
						</cfif>
					</td>			
		
				</tr>
				
				<!--- Calculo global de Totales --->
				<cfset gtotal_costo      = #gtotal_costo#      + #total_costo# >
				
			  </cfoutput> 
			</cfloop>
			
			<!--- Pintado global de Totales --->
			<tr><td colspan="9">&nbsp;</td></tr>
			<tr><td colspan="9">&nbsp;</td></tr>	
			<tr>
				<cfoutput> 
				<td colspan="8" class="topline"><b>Total General</b></td>
		
				<td align="right" class="topline" nowrap>
					<cfif #gtotal_costo# LT 0 >
						<b><font color="##FF0000">#LSNumberFormat( gtotal_costo,',9.00' )#</font></b>
					<cfelse>
						<b>#LSNumberFormat( gtotal_costo,',9.00' )#</b>
					</cfif>
				</td>			
				
				</cfoutput> 
			</tr>
			
			<tr> 
			  <td colspan="6">&nbsp;</td>
			</tr>
			<tr> 
			  <td colspan="6" class="topline">&nbsp;</td>
			</tr>
			<tr> 
			  <td colspan="6">&nbsp;</td>
			</tr>
			<tr> 
			  <td colspan="6"><div align="center">------------------ Fin del Reporte ------------------</div></td>
			</tr>
		<cfelse>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="6"><div align="center">------------------ No se encontraron registros ------------------</div></td></tr>
		</cfif>
  </table>
</form>