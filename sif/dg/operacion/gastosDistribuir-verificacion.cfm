<cfif isdefined("url.periodo") and not isdefined("form.periodo") >
	<cfset form.periodo = url.periodo >
</cfif>
<cfif isdefined("url.mes") and not isdefined("form.mes") >
	<cfset form.mes = url.mes >
</cfif>

<cf_templateheader title="Proceso de Distribuci&oacute;n de Gastos">

		<cfquery name="rsDatos1" datasource="#session.DSN#">
			select count(1)	as total
			from DGGastosxDistribuir
			where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		</cfquery>
		<cfquery name="rsDatos2" datasource="#session.DSN#">
			select count(1)	as total
			from DGGastosDistribuidos
			where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		</cfquery>
		
		<cf_dbtemp name="lista" returnvariable="lista" datasource="#session.DSN#">
			<cf_dbtempcol name="id" 				type="numeric" 	mandatory="yes">  
			<cf_dbtempcol name="codigo" 			type="char(10)" 	mandatory="yes">  			
			<cf_dbtempcol name="descripcion" 		type="varchar(80)" 	mandatory="yes">
			<cf_dbtempcol name="calculado" 			type="int" 		mandatory="yes">
			<cf_dbtempcol name="trasladado" 		type="int" 		mandatory="yes">
			<cf_dbtempcol name="montoDistribuido" 	type="money" 	mandatory="yes">
			<cf_dbtempcol name="montoDistribuir" 	type="money" 	mandatory="yes">			
			<cf_dbtempcol name="monto" 				type="money" 	mandatory="yes">
		</cf_dbtemp>
		<cfquery datasource="#session.DSN#">
			insert into #lista#( id, codigo, descripcion, calculado, trasladado, montoDistribuir, montoDistribuido, monto )
			select 	a.DGGDid, 
					a.DGGDcodigo, 
					a.DGGDdescripcion,
					(select count(1) from DGGastosxDistribuir where DGGDid=a.DGGDid and Periodo=#url.periodo# and Mes=#url.mes#),
					(select count(1) from DGGastosDistribuidos where DGGDid=a.DGGDid and Periodo=#url.periodo# and Mes=#url.mes# and trasladoDMF=1),
					

				  coalesce(( select sum(montodist)
				   from DGGastosxDistribuir gd
				   where gd.Periodo = #url.periodo#
					 and gd.Mes = #url.mes#
					 and gd.DGGDid =  a.DGGDid
				  ) , 0.00) as montoDistribuir,
				  
				  coalesce(( select sum(montoasignado)
				   from DGGastosDistribuidos gd
				   where gd.Periodo = #url.periodo#
					 and gd.Mes = #url.mes#
					 and gd.DGGDid =  a.DGGDid
					 and gd.original = 0
				  ) , 0.00) as montoDistribuido,

					coalesce((select sum(montodist) from DGGastosxDistribuir where DGGDid=a.DGGDid and Periodo=#url.periodo# and Mes=#url.mes#), 0.00) as monto
			from DGGastosDistribuir a
		</cfquery>

		<cfquery name="rsLista" datasource="#session.DSN#">
			select 	id as DGGDid,
					codigo, 
					descripcion, 
					case when calculado > 0 then '<img  src=''/cfmx/sif/imagenes/checked.gif'' />' else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' />' end as calculado,
					case when montoDistribuido = montoDistribuir then '<img  src=''/cfmx/sif/imagenes/checked.gif'' />' else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' />' end as ajustado,
					case when trasladado > 0 then '<img src=''/cfmx/sif/imagenes/checked.gif'' />' else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' />' end as trasladado,
					{fn concat({fn concat({fn concat('<img title=''Ir a Gastos por Distribuir'' style=''cursor:pointer;'' border=''0'' src=''/cfmx/sif/imagenes/iedit.gif'' onClick="javascript: consultar(', '''')}, <cf_dbfunction name="to_char" args="id"> )}, ''');">') } as  consultar,
					monto,
					'ok' as proceso,
					montoDistribuido,
					montoDistribuir
			from #lista#
		</cfquery>
		
		<cf_web_portlet_start border="true" titulo="Proceso de Distribuci&oacute;n de Gastos" >
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfoutput>
		<cfset listaMes = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'>
		<table width="100%" cellpadding="0" cellspacing="0" align="center">		
			<tr><td align="center" ><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td></tr>
			<tr><td align="center"><strong>Consulta de Gastos Distribuidos</strong></td></tr>
			<tr><td align="center"><strong>Per&iacute;odo:</strong> #form.periodo#</td></tr>
			<tr><td align="center"><strong>Mes:</strong> #listgetat(listaMes, form.mes)#</td></tr>
		</table>
		<br>
		</cfoutput>

			<form style="margin:0" action="distribuirGastos-sql.cfm" method="get" name="form1" id="form1" >
			<cfoutput>
			<input type="hidden" name="periodo" value="#url.periodo#" />
			<input type="hidden" name="mes" value="#url.mes#" />
			</cfoutput>
			<table align="center" border="0" cellspacing="0" cellpadding="10" width="100%" >
				<tr>
					<td colspan="2" align="center">
						<cfoutput>
						<cfset listaMes = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'>							
						<table width="98%" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td align="center">
									<cfset navegacion = '&periodo=#form.periodo#&mes=#form.mes#' >									
									<cfinvoke component="sif.Componentes.pListas"
											  	method="pListaQuery"
												returnvariable="pListaRet"
												query="#rsLista#"
												desplegar="codigo,descripcion,calculado,ajustado,trasladado,montoDistribuir,montoDistribuido,consultar"
												etiquetas="C&oacute;digo, Descripci&oacute;n,Calculado,Ajustado,Trasladado,Monto a distribuir,Monto distribuido,&nbsp;"
												formatos="S,S,S,S,S,M,M,S"
												align="left, left,center,center,center,right,right,center"
												showlink="true"
												showemptylistmsg="true"
												keys="DGGDid"
												formname="form1"
												ira="/cfmx/sif/dg/consultas/gastosDistribuidos.cfm"
												maxrows="20"
												incluyeForm="false"
												navegacion="#navegacion#"
												checkboxes="S" />
								</td>
							</tr>
						</table> 
						</cfoutput>
					</td>
				</tr>

				<tr>
					<td colspan="2" align="center">
						<input type="submit" name="btnAplicar" value="Calcular" class="btnAplicar" />
						<input type="submit" name="btnAjustar" value="Ajustar" class="btnAplicar" />
						<input type="submit" name="btnEliminar" value="Eliminar Cálculo" class="btnEliminar" />
						<input type="submit" name="btnRegresar" value="Regresar" class="btnAnterior" onclick="javascript:location.href='distribuirGastos-parametros.cfm'; return false;" />
					</td>
				</tr>
			</table>
		</form>
		<cf_web_portlet_end>
		<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			function consultar(id){
				document.form1.nosubmit = true;
				location.href = '/cfmx/sif/dg/catalogos/gastosDistribuir-tabs.cfm?proceso=ok&DGGDid='+id+'&periodo=#form.periodo#&mes=#form.mes#';
			}
			
			function ayuda_mostrar(){
				var pp = open('/cfmx/sif/dg/operacion/gastosDistribuir-ayuda.cfm', 'pp', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=400,left=200, top=100,screenX=100,screenY=100');
			}
		</script>
		</cfoutput>
	<cf_templatefooter>		