<cf_dbfunction name="OP_concat" returnvariable="_Cat">

<iframe src="" id="prueba" style="visibility:hiddend"  frameborder="0" width="0" height="0" ></iframe>

<cfif isDefined("url.periodo") and len(trim(url.periodo))>
	<cfset form.periodo = url.periodo>
</cfif>
<cfif isDefined("url.mes") and len(trim(url.mes))>
	<cfset form.mes = url.mes>
</cfif>
<cfif isDefined("url.mesDescrip") and len(trim(url.mesDescrip))>
	<cfset form.mesDescrip = url.mesDescrip>
</cfif>
<cfif isDefined("url.conceptoDescrip") and len(trim(url.conceptoDescrip))>
	<cfset form.conceptoDescrip = url.conceptoDescrip>
</cfif>
<cfif isDefined("url.concepto") and len(trim(url.concepto))>
	<cfset form.concepto = url.concepto>
</cfif>
<cfif isDefined("url.Edocumento") and len(trim(url.Edocumento))>
	<cfset form.Edocumento = url.Edocumento>
</cfif>

<!--- Datos de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo =  #session.ecodigo# 
</cfquery>

<!--- Crea la tabla de trabajo --->
<cf_dbtemp name="CONCILIAR" returnvariable="CONCILIAR" datasource="#session.dsn#">
	<cf_dbtempcol name="IDcontable" 	type="numeric"		mandatory="no">
	<cf_dbtempcol name="Ecodigo"  		type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="GATperiodo"  	type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="GATmes"  		type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="Cconcepto"  	type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="Ocodigo"  		type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="Odescripcion"  	type="varchar(100)" mandatory="yes">
	<cf_dbtempcol name="Edocumento"  	type="numeric"      mandatory="no">
	<cf_dbtempcol name="CFcuenta"  		type="numeric"      mandatory="yes">
	<cf_dbtempcol name="CFformato"  	type="varchar(100)" mandatory="yes">
	<cf_dbtempcol name="MontoGestion"  	type="money"  	    mandatory="yes">
	<cf_dbtempcol name="MontoAsiento"  	type="money"  		mandatory="yes">
	<cf_dbtempcol name="Conciliadas"  	type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="Completas"  	type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="Incompletas"  	type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="Aplicado"	  	type="numeric"  	mandatory="yes">	
	<cf_dbtempcol name="CantItems" 		type="numeric"  	mandatory="yes">		
</cf_dbtemp>

<!--- Insercion de los datos en la tabla de trabajo --->
<cfquery name="rsInsercion" datasource="#session.DSN#">
insert into #CONCILIAR#(
				IDcontable,
				Ecodigo,
				GATperiodo,
				GATmes,
				Cconcepto,
				Ocodigo,
				Odescripcion,
				Edocumento,
				CFcuenta,
				CFformato,
				MontoGestion,
				MontoAsiento,
				Conciliadas, 
				Completas, 
				Incompletas,
				Aplicado,
				CantItems)
select 			a.IDcontable,
				a.Ecodigo,
				a.GATperiodo,
				a.GATmes,
				a.Cconcepto,
				a.Ocodigo,
				d.Odescripcion,
				a.Edocumento,
				a.CFcuenta,
				c.CFformato,
				coalesce(sum(a.GATmonto),0.00) as MontoGestion, 
				000000000.0000 as MontoAsiento ,
				0 as Conciliadas,
				0 as Completas,
				0 as Incompletas,
				0 as Aplicado,
				count(1) as cantidad
from GATransacciones a
		inner join CFinanciera c
			on c.CFcuenta = a.CFcuenta
			and	c.Ecodigo = a.Ecodigo
		inner join Oficinas d
			on d.Ecodigo = a.Ecodigo
			and d.Ocodigo = a.Ocodigo
where a.Ecodigo 		=  #session.ecodigo# 
   and a.GATperiodo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
   and a.GATmes 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
group by  a.IDcontable,	a.Ecodigo,	a.GATperiodo,	  a.GATmes,		
		a.Cconcepto,	a.Ocodigo,	d.Odescripcion, a.Edocumento,		
		a.CFcuenta,	c.CFformato
</cfquery>

<!--- Insercion los datos de la conta que no existen en GATransacciones --->
<cfquery name="rsInsercion" datasource="#session.DSN#">
insert into #CONCILIAR#(
				IDcontable,
				Ecodigo,
				GATperiodo,
				GATmes,
				Cconcepto,
				Ocodigo,
				Odescripcion,
				Edocumento,
				CFcuenta,
				CFformato,
				MontoGestion,
				MontoAsiento,
				Conciliadas,
				Completas,
				Incompletas,
				Aplicado,
				CantItems)
select 			a.IDcontable,
				a.Ecodigo,
				a.Eperiodo,
				a.Emes,
				a.Cconcepto,
				a.Ocodigo,
				d.Odescripcion,
				a.Edocumento,
				a.CFcuenta,
				c.CFformato,
				000000000.0000 as MontoGestion , 
				coalesce(sum(a.Dlocal),0.00) as MontoAsiento,
				0 as Conciliadas,
				0 as Completas,
				0 as Incompletas,
				0 as Aplicado,
				count(1) as Cantidad
from HDContables a
		inner join CFinanciera c
			on c.CFcuenta = a.CFcuenta
			and	c.Ecodigo = a.Ecodigo
			
		inner join GACMayor gam
			on gam.Ecodigo=c.Ecodigo
			and gam.Cmayor=c.Cmayor
			
			and <cf_dbfunction name="like" args="c.CFformato #_Cat# '%'; gam.Cmascara" delimiters=";">
			
		inner join Oficinas d
			on d.Ecodigo = a.Ecodigo
			and d.Ocodigo = a.Ocodigo

where a.Ecodigo =  #session.ecodigo# 
   and Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
   and Emes		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
   and not exists(Select 1
   				  from #CONCILIAR# con
				  where con.Ecodigo		= a.Ecodigo
				    and con.GATperiodo	= a.Eperiodo
					and con.GATmes		= a.Emes
					and con.Edocumento	= a.Edocumento
					and con.Cconcepto 	= a.Cconcepto
					and con.Ocodigo 	= a.Ocodigo
					and con.CFcuenta 	= a.CFcuenta)

group by  a.IDcontable,	a.Ecodigo,	a.Eperiodo,	  a.Emes,		
		a.Cconcepto,	a.Ocodigo,	d.Odescripcion, a.Edocumento,		
		a.CFcuenta,	c.CFformato
</cfquery>

<!--- Actualizacion de la tabla de trabajo --->
<cfquery name="rsActualiza" datasource="#session.DSN#">
	update #CONCILIAR#
	  set MontoAsiento = (select coalesce(sum(b.Dlocal*(case b.Dmovimiento when 'D' then 1 else -1 end)),0.00)
						    from HDContables b
	                       where b.IDcontable = #CONCILIAR#.IDcontable
						     and b.Ocodigo  = #CONCILIAR#.Ocodigo
							 and b.CFcuenta = #CONCILIAR#.CFcuenta)
</cfquery>

<cfquery name="rsActualiza" datasource="#session.DSN#">
	update #CONCILIAR#
	set Conciliadas = coalesce(
					(	Select count(1)
						from GATransacciones gat
						where gat.Ecodigo 	= #CONCILIAR#.Ecodigo
						  and gat.Cconcepto	= #CONCILIAR#.Cconcepto
						  and gat.GATperiodo= #CONCILIAR#.GATperiodo
						  and gat.GATmes	= #CONCILIAR#.GATmes
						  and gat.Edocumento= #CONCILIAR#.Edocumento
						  and gat.Ocodigo	= #CONCILIAR#.Ocodigo
						  and gat.CFcuenta	= #CONCILIAR#.CFcuenta
						  and gat.GATestado = 2), 0 ),
						  
		Completas  = coalesce(
					(	Select count(1)
						from GATransacciones gat
						where gat.Ecodigo 	= #CONCILIAR#.Ecodigo
						  and gat.Cconcepto	= #CONCILIAR#.Cconcepto
						  and gat.GATperiodo= #CONCILIAR#.GATperiodo
						  and gat.GATmes	= #CONCILIAR#.GATmes
						  and gat.Edocumento= #CONCILIAR#.Edocumento
						  and gat.Ocodigo	= #CONCILIAR#.Ocodigo
						  and gat.CFcuenta	= #CONCILIAR#.CFcuenta
						  and gat.GATestado = 1), 0 ),
	
		Incompletas  = coalesce(
					(	Select count(1)
						from GATransacciones gat
						where gat.Ecodigo 	= #CONCILIAR#.Ecodigo
						  and gat.Cconcepto	= #CONCILIAR#.Cconcepto
						  and gat.GATperiodo= #CONCILIAR#.GATperiodo
						  and gat.GATmes	= #CONCILIAR#.GATmes
						  and gat.Edocumento= #CONCILIAR#.Edocumento
						  and gat.Ocodigo	= #CONCILIAR#.Ocodigo
						  and gat.CFcuenta	= #CONCILIAR#.CFcuenta
						  and gat.GATestado = 0), 0 )
</cfquery>

<!--- Insercion de los datos en la tabla de trabajo --->
<cfquery name="rsInsercion" datasource="#session.DSN#">
	insert into #CONCILIAR#(
					IDcontable,
					Ecodigo,
					GATperiodo,
					GATmes,
					Cconcepto,
					Ocodigo,
					Odescripcion,
					Edocumento,
					CFcuenta,
					CFformato,
					MontoGestion,
					MontoAsiento,
					Conciliadas, 
					Completas, 
					Incompletas,
					Aplicado,
					CantItems)
	
	select 			a.IDcontable,
					a.Ecodigo,
					a.GATperiodo,
					a.GATmes,
					a.Cconcepto,
					a.Ocodigo,
					d.Odescripcion,
					a.Edocumento,
					a.CFcuenta,
					c.CFformato,
					coalesce(sum(a.GATmonto),0.00) as MontoGestion , 
					000000000.0000 as MontoAsiento ,
					0 as Conciliadas,
					0 as Completas,
					0 as Incompletas,
					1 as Aplicado,
					count(1) as cantidad
					
	from GABTransacciones a
			inner join CFinanciera c
				on c.CFcuenta = a.CFcuenta
				and	c.Ecodigo = a.Ecodigo
			inner join Oficinas d
				on d.Ecodigo = a.Ecodigo
				and d.Ocodigo = a.Ocodigo
	
	where a.Ecodigo 		=  #session.ecodigo# 
	   and a.GATperiodo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
	   and a.GATmes 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
	   and a.GATeliminado		= 0
	   and not exists(Select 1
					  from #CONCILIAR# con
					  where con.Ecodigo		= a.Ecodigo
						and con.GATperiodo	= a.GATperiodo
						and con.GATmes		= a.GATmes
						and con.Edocumento	= a.Edocumento
						and con.Cconcepto 	= a.Cconcepto
						and con.Ocodigo 	= a.Ocodigo
						and con.CFcuenta 	= a.CFcuenta)
	group by  a.IDcontable,	a.Ecodigo,	a.GATperiodo,	  a.GATmes,		
			a.Cconcepto,	a.Ocodigo,	d.Odescripcion, a.Edocumento,		
			a.CFcuenta,	c.CFformato
</cfquery>

<!--- Actualizacion de la tabla de trabajo para los montos de los datos de gestion aplicados --->
<cfquery name="rsActualiza" datasource="#session.DSN#">
	update #CONCILIAR#
	set MontoGestion = coalesce((Select sum(b.GATmonto)
								  from GABTransacciones b
								where b.Ecodigo		 = #CONCILIAR#.Ecodigo
								  and b.GATperiodo	 = #CONCILIAR#.GATperiodo
								  and b.GATmes		 = #CONCILIAR#.GATmes
								  and b.Cconcepto 	 = #CONCILIAR#.Cconcepto
								  and b.Edocumento	 = #CONCILIAR#.Edocumento
								  and b.Ocodigo 	 = #CONCILIAR#.Ocodigo
								  and b.CFcuenta	 = #CONCILIAR#.CFcuenta 
								  and b.GATeliminado = 0),0.00)
	where (select count(1)
			from GABTransacciones gab
			where gab.Ecodigo   = #CONCILIAR#.Ecodigo
			and gab.GATperiodo	= #CONCILIAR#.GATperiodo
			and gab.GATmes		= #CONCILIAR#.GATmes
			and gab.Cconcepto	= #CONCILIAR#.Cconcepto
			and gab.Edocumento	= #CONCILIAR#.Edocumento
			and gab.Ocodigo 	= #CONCILIAR#.Ocodigo
			and gab.CFcuenta	= #CONCILIAR#.CFcuenta
			and gab.GATeliminado= 0) > 0
</cfquery>

<cfquery name="rsActualiza" datasource="#session.DSN#">
	update #CONCILIAR#
	set Aplicado = 1
	where MontoAsiento > 0
	  and MontoGestion > 0
	  and exists (	Select 1
					from GABTransacciones gab
					where gab.Ecodigo		= #CONCILIAR#.Ecodigo
					  and gab.GATperiodo	= #CONCILIAR#.GATperiodo
					  and gab.GATmes		= #CONCILIAR#.GATmes
					  and gab.Cconcepto		= #CONCILIAR#.Cconcepto
					  and gab.Edocumento	= #CONCILIAR#.Edocumento
					  and gab.GATeliminado	= 0
				  )
</cfquery>

<!--- Actualizacion de la tabla de trabajo --->
<cfquery name="rsActualiza" datasource="#session.DSN#">
	update #CONCILIAR#
		set MontoAsiento = (select coalesce(sum(b.Dlocal*(case b.Dmovimiento when 'D' then 1 else -1 end)),0.00)
							  from HDContables b
							where b.IDcontable = #CONCILIAR#.IDcontable
							and b.Ocodigo  = #CONCILIAR#.Ocodigo
							and b.CFcuenta = #CONCILIAR#.CFcuenta)
	where Aplicado = 1
</cfquery>

<!--- Consulta --->
<cfif not isdefined("resumido")>

	<cfquery name="rsReporte" datasource="#session.DSN#">
		Select b.Oficodigo as Oficina, 
			   c.CFformato as Cuenta,  
			   Cconcepto as Asiento, 
			   Edocumento as Documento,
			   CantItems as CantidadItems, 
			   
			   case when (Incompletas > 0) then
						'Incompleto'
				   when (Incompletas = 0 and Completas > 0) then
						'Completo'
				   when (Incompletas = 0 and Completas = 0 and Conciliadas > 0) then
						'Conciliado'
				   when (Incompletas = 0 and Completas = 0 and Conciliadas = 0 and Aplicado > 0) then
						'Aplicado'
				   else
						'No Definido'
				   end as Estado,
			   sum(MontoAsiento) as Monto_Asiento, 
			   sum(MontoGestion) as Monto_Gestion,
			   (sum(MontoAsiento) - sum(MontoGestion) ) as Monto_Dif
		
		from #CONCILIAR# a
				inner join Oficinas b
					on a.Ocodigo = b.Ocodigo
					and a.Ecodigo = b.Ecodigo
				inner join CFinanciera c
					on c.CFcuenta = a.CFcuenta
					and c.Ecodigo = a.Ecodigo
		
		group by b.Oficodigo,   c.CFformato, Cconcepto, 	Edocumento, 
				 CantItems, 	Completas, 	 Incompletas, 	Conciliadas, Aplicado 
		order by Cconcepto, 	Edocumento,  CantItems, 	b.Oficodigo,   
				 c.CFformato 
	</cfquery>

<cfelse>

	<cfquery name="rsReporte" datasource="#session.DSN#">
		Select b.Oficodigo as Oficina, 
			   c.CFformato as Cuenta,  
			   a.Cconcepto as Asiento,
			   sum(MontoAsiento) as Monto_Asiento, 
			   sum(MontoGestion) as Monto_Gestion,
			   (sum(MontoAsiento) - sum(MontoGestion) ) as Monto_Dif
		
		from #CONCILIAR# a
				inner join Oficinas b
					on a.Ocodigo = b.Ocodigo
					and a.Ecodigo = b.Ecodigo
				inner join CFinanciera c
					on c.CFcuenta = a.CFcuenta
					and c.Ecodigo = a.Ecodigo
		
		group by b.Oficodigo, c.CFformato, a.Cconcepto
		order by a.Cconcepto, b.Oficodigo, c.CFformato
	</cfquery>

</cfif>

<!--- Filtros --->
<cfset periodoD  = "(No definido)">
<cfset mesD      = "(No definido)">
<cfset conceptoD = "(No definido)">
<cfset documentoD = "(No definido)">
<cfif isDefined("form.periodo") and len(trim(form.periodo))>
	<cfset periodoD = form.periodo>
</cfif>
<cfif isDefined("form.mes") and len(trim(form.mes))>
	<cfset mesD = form.mesDescrip>
</cfif>
<cfif isDefined("form.concepto") and len(trim(form.concepto))>
	<cfset conceptoD = form.conceptoDescrip>
</cfif>
<cfif isDefined("form.Edocumento") and (len(trim(form.Edocumento)) and trim(form.Edocumento) neq 0)>
	<cfset documentoD = form.Edocumento>
</cfif>

<!--- Estilos --->
<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.titulo_empresa {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:12px;
		font-weight:bold;
		text-align:center;}
	.titulo_filtro {
		font-size:10px;
		font-weight:bold;
		text-align:center;}
	.titulo_columna {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.titulo_columnar {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.grupo1 {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}		
	.detalle {
		font-size:10px;
		text-align:left;}
	.detaller {
		font-size:10px;
		text-align:right;}
	.mensaje {
		font-size:10px;
		text-align:center;}
	.paginacion {
		font-size:10px;
		text-align:center;}
</style>

<!--- Botones --->
<cfif not isdefined('url.export')> 
	<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	<table  id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
		<cfoutput>
		<tr> 
			<td align="right" nowrap>
				<a href="javascript:regresar();" tabindex="-1">
					<img src="/cfmx/sif/imagenes/back.gif"
					alt="Regresar"
					name="regresar"
					border="0" align="absmiddle">
				</a>				
				<a href="javascript:imprimir();" tabindex="-1">
					<img src="/cfmx/sif/imagenes/impresora.gif"
					alt="Imprimir"
					name="imprimir"
					border="0" align="absmiddle">
				</a>
				<a id="EXCEL" href="javascript:SALVAEXCEL();" tabindex="-1">
					<img src="/cfmx/sif/imagenes/Cfinclude.gif"
					alt="Salvar a Excel"
					name="SALVAEXCEL"
					border="0" align="absmiddle">
				</a>								
			</td>
		</tr>
		<tr><td><hr></td></tr>
		</cfoutput>
	</table>
</cfif>

<!--- Variables --->
<cfset MaxLineasReporte = 57>	<!--- Mximo de l neas del reporte. --->
<cfset nLnEncabezado = 12>		<!--- Total de lneas del encabezado. Se le suma el agrupamiento. --->
<cfset nCols = 9>				<!--- Total de columnas del encabezado. --->

<!--- P gina --->
<cfif rsReporte.recordCount gt 0>
	<cfset paginas = rsReporte.recordCount / (MaxLineasReporte - nLnEncabezado)>
	<cfset pf = #Fix(paginas)#>
	<cfif #paginas# gt #pf#>
		<cfset paginas = #pf# + 1>
	</cfif>
<cfelse>
	<cfset pagina = 1>
	<cfset paginas = 1>
</cfif>

<!--- Llena el Encabezado --->
<cfsavecontent variable="encabezado">
	<cfoutput>	
		<tr><td colspan="#nCols#" class="titulo_empresa">#rsEmpresa.Edescripcion#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_reporte">Conciliacion de Activos Fijos</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">#mesD# de #periodoD#</td></tr>
		<!--- 
		<tr><td colspan="#nCols#" class="titulo_filtro">Concepto: #conceptoD#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">Documento: #documentoD#</td></tr>
		--->
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="#nCols#" align="center"><hr></td></tr>
		<tr>
			<td class="titulo_columna">Oficina</td>		
			<td class="titulo_columna">Cuenta</td>
			<td class="titulo_columna">Asiento</td>
			<cfif not isdefined("resumido")>
				<td class="titulo_columna">Documento</td>
				<td class="titulo_columna">Cantidad de Items</td>
			</cfif>
			<td class="titulo_columnar"><div align="center">Monto<br>Asiento Contable</div></td>
			<td class="titulo_columnar"><div align="center">Monto<br>Gestion de Activos</div></td>			
			<td class="titulo_columnar">Diferencias</td>
			<cfif not isdefined("resumido")>
				<td class="titulo_columna"><div align="center">Estado</div></td>
			</cfif>
		</tr>
		<tr><td colspan="#nCols#" align="center"><hr></td></tr>
	</cfoutput>
</cfsavecontent>

<!--- Llena el Detalle --->
<cfsavecontent variable="detalle">
	<cfoutput>
		<cfif rsReporte.recordcount gt 0>
			<cfset pagina = 1>
			<cfset contador = nLnEncabezado>		
			<cfset paginaNueva = false>
			<cfset vCentroFuncional = -1>
			<cfset vCategoria = -1>
			<cfset vClase = -1>
			<cfloop query="rsReporte">
 				<!--- Pinta el Encabezado --->
				<cfif contador gte MaxLineasReporte>
					<tr><td class="paginacion" colspan="#nCols#"> - P&aacute;g #pagina# / #paginas# - </td></tr>
					<tr class="corte"><td colspan="#nCols#" nowrap>&nbsp;</td></tr>
					#encabezado#
					<cfset paginaNueva = true>
					<cfset contador = nLnEncabezado>
					<cfset pagina = pagina + 1>
				</cfif>
				<tr>				
					<td class="detalle" nowrap="nowrap">#trim(Oficina)#</td>
					<td class="detalle" nowrap="nowrap">#trim(Cuenta)#</td>
					<td class="detalle" nowrap="nowrap">#trim(Asiento)#</td>
					<cfif not isdefined("resumido")>
						<td class="detalle" nowrap="nowrap">#trim(Documento)#</td>
						<td class="detalle" nowrap="nowrap">#trim(CantidadItems)#</td>					
					</cfif>
					<td class="detaller" nowrap="nowrap">#LSNumberFormat(Monto_Asiento,',9.00')#</td>
					<td class="detaller" nowrap="nowrap">#LSNumberFormat(Monto_Gestion,',9.00')#</td>					
					<td class="detaller" nowrap="nowrap">#LSNumberFormat(Monto_Dif,',9.00')#</td>
					<cfif not isdefined("resumido")>
						<td class="detaller" nowrap="nowrap">#trim(Estado)#</td>
					</cfif>
				</tr>				
				<cfset contador = contador + 1>
				<cfset paginaNueva = false>
			</cfloop>
		<cfelse>
			<tr><td colspan="#nCols#" align="center">&nbsp;</td></tr>
			<tr><td colspan="#nCols#" class="mensaje"> --- La consulta no gener&oacute; ning&uacute;n resultado --- </td></tr>
		</cfif>
	</cfoutput>
</cfsavecontent>

<!--- Forma el Reporte  --->
<cfoutput>
<cfsavecontent variable="reporte">
	<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
		#encabezado#
		#detalle#
		<tr><td colspan="#nCols#" align="center">&nbsp;</td></tr>
		<tr><td colspan="#nCols#" class="paginacion"> - P&aacute;g #pagina# / #paginas# - </td></tr>
	</table>
</cfsavecontent>
</cfoutput>

<!--- Pinta el Reporte --->
<cfoutput>
<cfif isdefined('url.export')>
	 <cfcontent type="application/msexcel">
				<cfheader 	name="Content-Disposition"  
					value="attachment;filename=ConciliacionAF#session.Usulogin##LSDateFormat(now(), 			'yyyymmdd')#.xls" >
</cfif> 
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
	#reporte#
</table>
</cfoutput>

<!--- Manejo de los Botones --->
<script language="javascript1.2" type="text/javascript">
	function regresar() {
		history.back();
	}

	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print();
        tablabotones.style.display = '';
	}
	
	function SALVAEXCEL() {
		<cfset params = 'export=1' >
		<cfif isdefined("form.periodo")>
			<cfset params = params & "&periodo=#form.periodo#" >
		</cfif>
		<cfif isdefined("form.mes")>
			<cfset params = params & "&mes=#form.mes#" >
		</cfif>
		<cfif isdefined("form.concepto")>
			<cfset params = params & "&concepto=#form.concepto#" >	
		</cfif>
		<cfif isdefined("form.Edocumento")>
			<cfset params = params & "&Edocumento=#form.Edocumento#" >	
		</cfif>
		<cfif isdefined("form.mesDescrip")>
			<cfset params = params & "&mesDescrip=#form.mesDescrip#" >	
		</cfif>
		<cfif isdefined("form.conceptoDescrip")>
			<cfset params = params & "&conceptoDescrip=#form.conceptoDescrip#" >	
		</cfif>				
		
		var ira = '?<cfoutput>#jsstringformat(params)#</cfoutput>';
		document.getElementById("prueba").src="gabRptConciliacionActivosRep.cfm" + ira;
	}
</script>