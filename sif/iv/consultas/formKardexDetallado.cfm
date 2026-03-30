<cfinclude template="../../Utiles/sifConcat.cfm">
<!---<cfdump var="#url#">
<cf_dump var="#form#">--->

<cfset LvarTipoMovInter = 0>

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

<cfif isdefined("url.Fechadesde")>
	<cfparam name="Form.Fechadesde" default="#url.Fechadesde#">
</cfif>

<cfif isdefined("url.Fechahasta")>
	<cfparam name="Form.Fechahasta" default="#url.Fechahasta#">
</cfif>
<cfif isdefined("url.Ktipo")>
	<cfparam name="Form.Ktipo" default="#url.Ktipo#">
    <cfif Form.Ktipo eq 'M' or Form.Ktipo eq 'T'>
    	<cfset LvarTipoMovInter = 1>
	</cfif>
</cfif>


<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif isdefined("form.Dcodigo") and len(trim(form.Dcodigo))>
	<cfquery name="rsDcodigo" datasource="#session.DSN#">
		select Deptocodigo #_Cat# Ddescripcion as Departamento
		from Departamentos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dcodigo#">
	</cfquery>
</cfif>

<cfinvoke component="sif.Componentes.IV_SIF_IN0003" method="Kardex_Detallado_Almacen" returnvariable="rsProc">
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
	<cfif isdefined("Form.Dcodigo") and len(trim(Form.Dcodigo))>
		<cfinvokeargument name="Dcodigo" value="#form.Dcodigo#"/>
	</cfif>

	<cfif isdefined("Form.Fechadesde") and len(trim(Form.Fechadesde))>
		<cfinvokeargument name="Fechadesde" value="#form.Fechadesde#"/>
	</cfif>

	<cfif isdefined("Form.Fechahasta") and len(trim(Form.Fechahasta))>
		<cfinvokeargument name="Fechahasta" value="#form.Fechahasta#"/>
	</cfif>
	<cfif isdefined("Form.Ccodigo") and Form.Ccodigo neq "" >
		<cfinvokeargument name="Ccodigo" value="#form.Ccodigo#"/>
	</cfif>		
	<cfif isdefined("Form.CcodigoF") and Form.CcodigoF neq "" >
		<cfinvokeargument name="CcodigoF" value="#form.CcodigoF#"/>
	</cfif>		
    <cfif isdefined("Form.Ktipo") and Form.Ktipo neq "" >
		<cfinvokeargument name="Kartipo" value="#Form.Ktipo#"/>
        <cfif Form.Ktipo eq 'M' or Form.Ktipo eq 'T'>
        	<cfset LvarTipoMovInter = 1>
        </cfif>
	</cfif>	
				
	<cfinvokeargument name="debug" value="N"/>							
</cfinvoke>
	

<form name="form1" method="post">

	<cfif isdefined("form.toExcel")>
		<cfcontent type="application/msexcel">
		<cfheader 	name="Content-Disposition" 
		value="attachment;filename=KardexDetallado_#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
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
		.marco {
			border-top-width: 1px;
			border-top-style: solid;
			border-right-style: none;
			border-bottom-width: 1px;
			border-bottom-style: none;
			border-left-style: none;
			border-top-color: #CCCCCC;
		}
		.subTituloRep {
			font-weight: bold; 
			font-size: x-small; 
			background-color: #F5F5F5;
		}
		.cell_line {
			border-bottom-width: 1px;
	
			border-bottom-style: solid;
			border-right-width: 1px;
			border-right-style: solid;
			border-top-width: 1px;
			border-top-style: solid;
			border-left-width: 1px;
			border-left-style: solid;
			border-bottom-color: #CCCCCC;
		}
	} 
	</style>

  <table width="<cfif LvarTipoMovInter eq 0>100%<cfelseif LvarTipoMovInter eq 1>110%</cfif>" border="0" cellspacing="0" cellpadding="0" >
    <!--- <table width="100%" border="1" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center"> --->
    <tr> 
      <td colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
    </tr>
    <tr> 
      <td colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>">&nbsp;</td>
    </tr>
    <tr> 
      <td  colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>" align="center"><b>Reporte de Kardex Detallado</b></td>
    </tr>
    <cfif form.almini neq "" and form.almfin neq "">
        <tr> 
          <td colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>" width="50%" align="center" style="padding-right: 20px"> 
                <b>Rango de Almac&eacute;n:</b> desde <cfoutput>#get_almacen( form.almini ).Bdescripcion#</cfoutput> hasta <cfoutput>#get_almacen(form.almfin).Bdescripcion#</cfoutput> &nbsp; </td>
        </tr>
	</cfif>		

    <tr> 
      <td colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>" width="50%" align="center" style="padding-right: 20px"> 
        <cfoutput>
        <cfif isdefined("Form.Fechadesde") and len(trim(Form.Fechadesde)) and isdefined("Form.Fechahasta") and len(trim(Form.Fechahasta))>
        	<b>Desde </b> #Form.Fechadesde# <b>Hasta</b> #Form.Fechahasta# &nbsp; </td>
        <cfelse>
			<b>Desde </b> #get_mes(form.mesini).VSdesc#-#form.perini# <b>Hasta</b> #get_mes(form.mesfin).VSdesc#-#form.perfin# &nbsp; </td>
		</cfif>            
        </cfoutput>    
	</tr>

    <cfquery name="rsAlmacenes" dbtype="query">
    	select distinct Alm_Aid, Bdescripcion 
		from rsProc 
		order by Bdescripcion
    </cfquery>

	<!--- Total por Global--->
	<cfset gtotal_centradas  = 0 >
	<cfset gtotal_salidas    = 0 >
	<cfset gtotal_saldocosto = 0 >		  
	<cfset gtotal_costoprom  = 0 >

	<cfflush interval="64">
	
	<cfloop query="rsAlmacenes">
 
        <tr> 
          <td colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>18</cfif>" class="bottomline">&nbsp;</td>
        </tr>

        <tr> 
		  <cfoutput>
		  <td  colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>18</cfif>" class="tituloListas"><div align="center"><font size="3">#rsAlmacenes.Bdescripcion#</font></div></td>
		  </cfoutput>
        </tr>

        <tr> 
          <cfif isdefined("form.toExcel")>
          	<td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" width="6%" rowspan="2" align="center"><strong>Articulo</strong></td>
          </cfif>
          <td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" width="6%" rowspan="2" align="center"><strong>Per&iacute;odo&nbsp;&nbsp;</strong></td>
          <td style=" border-bottom:1px solid black;  border-top:1px solid black;" rowspan="2" width="5%"><strong>Usuario</strong></td>
          <td style=" border-bottom:1px solid black;  border-top:1px solid black; text-align:center;" rowspan="2" width="4%"><strong>Fecha</strong></td>
          <td style=" border-bottom:1px solid black;  border-top:1px solid black;" rowspan="2" width="6%"><div align="center"><strong>Documento</strong></div></td>
          <td style=" border-bottom:1px solid black;  border-top:1px solid black;" width="6%" rowspan="2" ><div align="center"><strong>Tipo</strong></div></td>
          <td style=" border-bottom:1px solid black;  border-top:1px solid black;" rowspan="2" width="12%"><div align="center"><strong>Departamento</strong></div></td>
          <cfif LvarTipoMovInter eq 1>
				<td style=" border-bottom:1px solid black;  border-top:1px solid black;" rowspan="2" width="13%"><div align="center"><strong>Almacen Destino/Origen</strong></div></td>
          </cfif>
          <td style=" border-bottom:1px solid black;  border-top:1px solid black; border-left:1px solid black;  " colspan="2" align="center"><div align="center"><strong>Ubicaci&oacute;n</strong></div></td>
          <td style=" border-bottom:1px solid black;  border-top:1px solid black; border-left:1px solid black; border-right:1px solid black; " colspan="4" align="center"><div align="center"><strong>Unidades</strong></div></td>
          <td style=" border-bottom:1px solid black;  border-top:1px solid black; border-right:1px solid black; " colspan="3" align="center"><div align="center"><strong>Costo</strong></div></td>
		  <td style="  border-top:1px solid black;  border-right:1px solid black;"    align="right" ><strong>Costo</strong></td>		  
        </tr>
        <tr > 
          <td  style="border-bottom:1px solid black; border-left:1px solid black;" align="center"><strong>Estante-</strong></td>
          <td  style="border-bottom:1px solid black;" align="center"><strong>Casilla</strong></td>
          <td  width="9%" style="border-bottom:1px solid black; border-left: 1px solid black; " align="center"><strong>Entradas</strong></td>
          <td  width="9%" style="border-bottom:1px solid black; border-left: 1px solid black;  " align="center"><strong>Salidas</strong></td>
          <td  width="9%" style="border-bottom:1px solid black; border-left: 1px solid black; border-right: 1px solid black;" align="center"><strong>Saldo</strong></td>
          <td  width="9%" style="border-bottom:1px solid black;  " align="center"><strong>Costo Unitario</strong></td>
          <td width="9%"  style="border-bottom:1px solid black; border-left: 1px solid black;" align="center"><strong>Entradas</strong></td>
          <td  width="9%" style="border-bottom:1px solid black; border-left: 1px solid black; border-right: 1px solid black; " align="center"><strong>Salidas</strong></td>
          <td  width="9%" style="border-bottom:1px solid black; border-right:1px solid black;" align="center"><strong>Saldo</strong></td>
		  <td  width="9%" style="border-bottom:1px solid black; border-right:1px solid black;" align="right"><strong>Promedio</strong></td>
        </tr>

        <cfquery name="rsArticulos" dbtype="query">
        	select distinct Aid, Acodigo, Acodalterno, Adescripcion, Alm_Aid
			from rsProc 
			where Alm_Aid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAlmacenes.Alm_Aid#">
            <cfif isdefined("form.sinMovimientos")>
                and (Entradas > 0 or  Salidas > 0)
            <cfelseif isdefined("form.ConMovimientos")>    <!--- Se incluyen en el reporte unicamente los articulos sin movimientos --->
				and (Entradas = 0 or  Salidas = 0)
            </cfif>
			order by Acodigo
        </cfquery>
        
		
		<!--- Total por Almacen --->
		<cfset atotal_centradas  = 0 >
		<cfset atotal_salidas    = 0 >
		<cfset atotal_saldocosto = 0 >
		<cfset atotal_costoprom = 0 >	
          
             <!--- <cfdump var="#rsArticulos#">	   --->
           <!--- <cfdump var="#rsKid#">   --->
           
		<cfset LvarAlmacenOri = "">
        <cfloop query="rsArticulos">
			<cfquery name="rsDetalle" dbtype="query">
				select 
                			Kperiodo, 
                			Kmes, 
                            Dcodigo, 
                            CCTcodigo, 
                            Ktipo, 
                            Kdocumento, 
                            Kfecha, 
                            Entradas, 
                            Salidas, 
                            SaldoUnidades, 
                            CEntradas, 
                            CSalidas, 
                            SaldoCosto, 
                            CostoUnitario, 
                            Usuario,
                			Eestante,
                            Ecasilla,
                            Kid2,
                            KtipoEs
                            
				from rsProc 
				where Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsArticulos.Acodigo#">
					and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.Alm_Aid#">
				order by Kid 
			</cfquery>
            
			<cfoutput>
				<tr> 
				  <cfset articulo = rsArticulos.Adescripcion>
				  <cfif Len(rsArticulos.Adescripcion) GT 40 >
					<cfset articulo = Mid(rsArticulos.Adescripcion, 1, 40) & "...">
				  </cfif>
				  <cfif not isdefined("form.toExcel")>
					<!--- <td  colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>"class="tituloAlterno"><div align="left"><font size="2"><strong>#rsArticulos.Acodigo# - #articulo# - #rsArticulos.Acodalterno#</strong></font></div></td>
				  <cfelse> --->
					<td  colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>"class="tituloAlterno"><div align="left"><font size="2"><strong><a href="SQLArticulo.cfm?Aid=#rsArticulos.Aid#&almini=#form.almini#&almfin=#form.almfin#&perini=#form.perini#&mesini=#form.mesini#&perfin=#form.perfin#&mesfin=#form.mesfin#" title="#rsArticulos.Adescripcion#">#rsArticulos.Acodigo# - #articulo# - #rsArticulos.Acodalterno#</a></strong></font></div></td>
				  </cfif>  
				</tr>
			</cfoutput>
		  
			<!--- Total por Articulo/Almacen --->
			<cfset total_centradas  = 0 >
			<cfset total_salidas    = 0 >
			<cfset total_saldocosto = 0 >		  

			<cfoutput query="rsDetalle">
				<cfquery name="rsDep" datasource="#session.DSN#">
					select ltrim(rtrim(Deptocodigo)) #_Cat# ' - ' #_Cat# ltrim(rtrim(Ddescripcion))  as Departamento
					from Departamentos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and Dcodigo = #rsDetalle.Dcodigo#
				</cfquery>
				<tr> 
                	<cfif isdefined("form.toExcel")>
	                	<td  align="left">#rsArticulos.Acodigo# - #articulo# - #rsArticulos.Acodalterno#</td>
                    </cfif>
					<td  align="left"><cfif len(trim(#rsDetalle.Kperiodo#)) NEQ 0 >#rsDetalle.Kperiodo#/#LSNumberFormat(rsDetalle.Kmes,"00")#<cfelse>&nbsp;</cfif></td>
					<!--- Usuario --->
                    <td  align="center"  style="font-size:10px;"><cfif rsDetalle.Usuario neq "">#get_NombreUsuario(rsDetalle.Usuario)#</cfif></td>
					<td  align="right"><cfif rsDetalle.Kfecha neq "">#LSDateFormat(rsDetalle.Kfecha, "dd/mm/yyyy")# <cfelse>&nbsp;</cfif></td>
					<td  align="center"  style="font-size:10px;" >&nbsp;#rsDetalle.Kdocumento#&nbsp;</td>
					<td  align="center" style="font-size:10px;">#rsDetalle.Ktipo#</td>
					<td  align="center" style="font-size:10px; ">#rsDep.Departamento#</td>
                    <cfif LvarTipoMovInter eq 1>
                    	<td  align="center" style="font-size:10px;"><cfif get_Aid(rsDetalle.Kid2, rsDetalle.KtipoEs) neq -1>#get_almacen(get_Aid(rsDetalle.Kid2, rsDetalle.KtipoEs)).Bdescripcion#</cfif></td>
                    </cfif>
                    <td  align="center">#rsDetalle.Eestante#</td>
                    <td  align="center">#rsDetalle.Ecasilla#</td>
					<td  width="9%"  	style="border-left:1px solid lightgray;" align="right">#LSNumberFormat( rsDetalle.Entradas, ',9.00000')#</td>
					<td  width="9%"  	style="border-left:1px solid lightgray;" align="right">#LSNumberFormat( rsDetalle.Salidas, ',9.00000')#</td>
					<td   width="9%" 	style="border-left:1px solid lightgray;" align="right">#LSNumberFormat( rsDetalle.SaldoUnidades, ',9.00000')#</td>
					<td   width="9%" 	style="border-left:1px solid lightgray; border-right:1px solid  lightgray;" align="right">#LSNumberFormat( rsDetalle.CostoUnitario, ',9.00000')#</td>
					
					<td  width="9%" align="right" style="border-right:1px solid  lightgray;" >
					  <cfif #rsDetalle.CEntradas# LT 0 >
						  <font color="##FF0000">#LSNumberFormat( rsDetalle.CEntradas,',9.00' )#</font>
					  <cfelse>
						  #LSNumberFormat( rsDetalle.CEntradas,',9.00' )#
					  </cfif>			  </td>			
					
					<td  width="9%" align="right" style="border-right:1px solid  lightgray;"  >
					  <cfif #rsDetalle.CSalidas# LT 0 >
						  <font color="##FF0000">#LSNumberFormat( rsDetalle.CSalidas,',9.00' )#</font>
					  <cfelse>
						  #LSNumberFormat( rsDetalle.CSalidas,',9.00' )#
					  </cfif>			  </td>			
					
					<td width="9%" align="right"  style="border-right:1px solid  lightgray;" >
					  <cfif #rsDetalle.SaldoCosto# LT 0 >
						  <font color="##FF0000">#LSNumberFormat( rsDetalle.SaldoCosto,',9.00' )#</font>
					  <cfelse>
						  #LSNumberFormat( rsDetalle.SaldoCosto,',9.00' )#
					  </cfif>			  </td>
					<td  width="9%" align="right">
					<cfif #rsDetalle.SaldoUnidades# NEQ 0 >
						#LSNumberFormat( rsDetalle.SaldoCosto/rsDetalle.SaldoUnidades, ',9.00000')#
					<cfelse>
						#LSNumberFormat( 0, ',9.00000')#
					</cfif>
					</td>
				</tr>
				<!--- Calcula Totales por Articulo/Almacen --->
				<cfset total_centradas  = total_centradas  + rsDetalle.CEntradas >
				<cfset total_salidas    = total_salidas    + rsDetalle.CSalidas >
				<cfset total_saldocosto = rsDetalle.SaldoCosto >		
				<cfif rsDetalle.SaldoUnidades NEQ 0 >
					<cfset total_costoprom = rsDetalle.SaldoCosto/rsDetalle.SaldoUnidades>		
				<cfelse>
					<cfset total_costoprom = LSNumberFormat(0 , ',9.00000') >		 
				</cfif>
			</cfoutput>
			
            <cfif not isdefined("form.toExcel")>
					<cfoutput>		  
                    <!--- Pintado de Totales por Articulo/Almacen --->
                    <tr>
                        <td  colspan="<cfif LvarTipoMovInter eq 0>12<cfelse>13</cfif>" class="topline"><b>Total</b></td>
                    
                        <td align="right"  class="topline" style=" border-right: 1px solid lightgray;">
                            <cfif #total_centradas# LT 0 >
                                <b><font color="##FF0000">#LSNumberFormat( total_centradas,',9.00' )#</font></b>
                            <cfelse>
                                <b>#LSNumberFormat( total_centradas,',9.00' )#</b>
                            </cfif>
                        </td>			
                    
                        <td align="right"  class="topline" style=" border-right: 1px solid lightgray;">
                            <cfif #total_salidas# LT 0 >
                                <b><font color="##FF0000">#LSNumberFormat( total_salidas,',9.00' )#</font></b>
                            <cfelse>
                                <b>#LSNumberFormat( total_salidas,',9.00' )#</b>
                            </cfif>
                        </td>			
                    
                        <td align="right"  class="topline" style=" border-right: 1px solid lightgray;">
                            <cfif #total_saldocosto# LT 0 >
                                <b><font color="##FF0000">#LSNumberFormat( total_saldocosto,',9.00' )#</font></b>
                            <cfelse>
                                <b>#LSNumberFormat( total_saldocosto,',9.00' )#</b>
                            </cfif>
                        </td>
                        <td  class="topline" align="right" style=" border-right: 1px solid lightgray;">
                            <cfif #total_costoprom# LT 0 >
                                <b><font color="##FF0000">#LSNumberFormat( total_costoprom,',9.00000' )#</font></b>
                            <cfelse>
                                <b>#LSNumberFormat( total_costoprom,',9.00000' )#</b>
                            </cfif>
                        </td>			
                    </tr>
                    </cfoutput>
                <tr><td colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>">&nbsp;</td></tr>
			</cfif>
			<!--- Calcula Totales por Almacen --->
			<cfset atotal_centradas  = atotal_centradas  + total_centradas >
			<cfset atotal_salidas    = atotal_salidas    + total_salidas >
			<cfset atotal_saldocosto = atotal_saldocosto + total_saldocosto >		  
			<cfset atotal_costoprom  = atotal_costoprom  + total_costoprom >		  
        </cfloop>

		<cfif not isdefined("form.toExcel")>
			<!--- Pintado de Totales por Articulo/Almacen --->
            <cfoutput>
            <tr>
                <td colspan="<cfif LvarTipoMovInter eq 0>12<cfelse>13</cfif>" class="topline"><b>Total por Almac&eacute;n</b></td>
            
                <td align="right"  class="topline" style=" border-right: 1px solid lightgray;">
                    <cfif #atotal_centradas# LT 0 >
                        <b><font color="##FF0000">#LSNumberFormat( atotal_centradas,',9.00' )#</font></b>
                    <cfelse>
                        <b>#LSNumberFormat( atotal_centradas,',9.00' )#</b>
                    </cfif>
                </td>			
            
                <td align="right"  class="topline" style=" border-right: 1px solid lightgray;">
                    <cfif #atotal_salidas# LT 0 >
                        <b><font color="##FF0000">#LSNumberFormat( atotal_salidas,',9.00' )#</font></b>
                    <cfelse>
                        <b>#LSNumberFormat( atotal_salidas,',9.00' )#</b>
                    </cfif>
                </td>
    
                <td align="right"  class="topline" style=" border-right: 1px solid lightgray;">
                    <cfif #atotal_saldocosto# LT 0 >
                        <b><font color="##FF0000">#LSNumberFormat( atotal_saldocosto,',9.00' )#</font></b>
                    <cfelse>
                        <b>#LSNumberFormat( atotal_saldocosto,',9.00' )#</b>
                    </cfif>
                </td>
    
                <td  class="topline" align="right" style=" border-right: 1px solid lightgray;">
                    <cfif #atotal_costoprom# LT 0 >
                        <b><font color="##FF0000">#LSNumberFormat( atotal_costoprom,',9.00' )#</font></b>
                    <cfelse>
                        <b>#LSNumberFormat( atotal_costoprom,',9.00' )#</b>
                    </cfif>
                </td>
            </tr>
            <tr><td colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>">&nbsp;</td></tr>
            </cfoutput>
		</cfif>
			<!--- Calcula global de Totales --->
            <cfset gtotal_centradas  = gtotal_centradas  + atotal_centradas >
            <cfset gtotal_salidas    = gtotal_salidas    + atotal_salidas >
            <cfset gtotal_saldocosto = gtotal_saldocosto + atotal_saldocosto >		  
            <cfset gtotal_costoprom  = gtotal_costoprom  + atotal_costoprom >		  
        </cfloop>
    <tr> 
      <td colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>" class="topline">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>">&nbsp;</td>
    </tr>
	<!--- Pintado de Total Global --->
	<cfif not isdefined("form.toExcel")>
		<cfoutput>
            <tr>
                <td  colspan="<cfif LvarTipoMovInter eq 0>12<cfelse>13</cfif>" class="topline"><b>Total General</b></td>
                
                <td align="right"  class="topline" style=" border-right: 1px solid lightgray;">
                    <cfif #gtotal_centradas# LT 0 >
                        <b><font color="##FF0000" style=" border-right: 1px solid lightgray;">#LSNumberFormat( gtotal_centradas,',9.00' )#</font></b>
                    <cfelse>
                        <b>#LSNumberFormat( gtotal_centradas,',9.00' )#</b>
                    </cfif>			</td>			
                
                <td align="right"  class="topline" style="border-right: 1px solid lightgray;">
                    <cfif #gtotal_salidas# LT 0 >
                        <b><font color="##FF0000">#LSNumberFormat( gtotal_salidas,',9.00' )#</font></b>
                    <cfelse>
                        <b>#LSNumberFormat( gtotal_salidas,',9.00' )#</b>
                    </cfif>			</td>			
                
                <td align="right"  class="topline" style="border-right: 1px solid lightgray;">
                    <cfif #gtotal_saldocosto# LT 0 >
                        <b><font color="##FF0000">#LSNumberFormat( gtotal_saldocosto,',9.00' )#</font></b>
                    <cfelse>
                        <b>#LSNumberFormat( gtotal_saldocosto,',9.00' )#</b>
                    </cfif>			</td>
                <td align="right" class="topline" style=" border-right: 1px solid lightgray;">
                    <cfif #gtotal_costoprom# LT 0 >
                        <b><font color="##FF0000">#LSNumberFormat( gtotal_costoprom,',9.00' )#</font></b>
                    <cfelse>
                        <b>#LSNumberFormat( gtotal_costoprom,',9.00' )#</b>
                    </cfif>			</td>			
            </tr>
        </cfoutput>
     </cfif>   	
	<tr><td colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>">&nbsp;</td></tr>
	
    <tr> 
      <td colspan="<cfif LvarTipoMovInter eq 0>16<cfelse>17</cfif>"><div align="center">------------------ Fin del Reporte ------------------</div></td>
    </tr>
  </table>
</form>

<cffunction name="get_almacen" access="public" returntype="query">
	<cfargument name="aid" type="numeric" required="true" default="0" >
	<cfquery name="rsget_almacen" datasource="#session.DSN#" >
		select rtrim(Bdescripcion) as Bdescripcion from Almacen
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#aid#">
	</cfquery>
	<cfreturn #rsget_almacen#>
</cffunction>

<cffunction name="get_Aid" access="public" returntype="numeric">
	<cfargument name="Kid" type="numeric" required="true" default="0">
    <cfargument name="KtipoEs" type="string" required="true">
	 <cfset LvarKid = -1>
     <cfquery name="rsAlmacenDestino" datasource="#session.dsn#">
                    select  coalesce(AO.Aid,-1) as Aid
                    from Kardex Origen
                        inner join Almacen AD
                        	on Origen.Alm_Aid = AD.Aid
                        LEFT OUTER JOIN Kardex Destino
                        inner join Almacen AO
                        	on Destino.Alm_Aid = AO.Aid
                        
                        on Origen.Aid =  Destino.Aid
                        and Origen.Ecodigo = Destino.Ecodigo
                        and Origen.Ktipo = Destino.Ktipo
                        and Origen.Kdocumento = Destino.Kdocumento
                        and Origen.Kreferencia = Destino.Kreferencia
                        and Destino.KtipoES = <cfif Arguments.KtipoEs eq 'E'>'S'<cfelse>'E'</cfif>
                    where Origen.Kid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Kid#">
                    and Origen.KtipoES = <cfif Arguments.KtipoEs eq 'E'>'E'<cfelse>'S'</cfif>
                </cfquery> 
                <cfif rsAlmacenDestino.Aid neq "">
                	<cfset LvarKid = rsAlmacenDestino.Aid>
                </cfif>
    <cfreturn #LvarKid#>
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
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
 <cffunction name="get_NombreUsuario" access="public" returntype="string">
	<cfargument name="Usulogin" type="string" required="true">
    <cfset LvarUsuario = "">
	<cfquery name="rsget_Usuario" datasource="#session.DSN#" >
        select dt.Pnombre #_Cat#' '#_Cat#dt.Papellido1 as usuario
        from Usuario u
        	inner join DatosPersonales dt
        		on u.datos_personales = dt.datos_personales 
        where  u.Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Usulogin#">
	</cfquery>
    <cfset LvarUsuario =#rsget_Usuario.usuario#>
	<cfreturn #LvarUsuario#>
</cffunction>
 

            
             


