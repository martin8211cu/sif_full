<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>\
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="dataDReclamos" datasource="#session.DSN#">
	select 	a.ERid,
			a.DRid, 
			a.DDRlinea, 
			a.DRcantorig, 
			a.DRcantrec, 
			#LvarOBJ_PrecioU.enSQL_AS("a.DRpreciooc")#, 
			#LvarOBJ_PrecioU.enSQL_AS("a.DRpreciorec")#, 
			a.DRfecharec, 
			a.DRestado, 
			a.DDRobsreclamo, 
			case when b.DDRtipoitem = 'A' then rtrim(d.Acodigo)#_Cat#' - '#_Cat#c.DOdescripcion
				 when b.DDRtipoitem = 'S' then rtrim(e.Ccodigo)#_Cat#' - '#_Cat#c.DOdescripcion
				 else c.DOdescripcion
			end as DOdescripcion
	
	from DReclamos a
	
		inner join DDocumentosRecepcion b
			on a.DDRlinea = b.DDRlinea
		
		inner join DOrdenCM c
			on b.DOlinea=c.DOlinea

		left outer join Articulos d
			on b.Ecodigo = d.Ecodigo
			and b.Aid = d.Aid
		
		left outer join Conceptos e
			on b.Ecodigo = e.Ecodigo
			and b.Cid = e.Cid
	
	where a.ERid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
	order by DOdescripcion
</cfquery>


<cfoutput>

<cfset destado = ArrayNew(1)>
<cfset destado[10] = 'En Proceso'>
<cfset destado[20] = 'Producto Entregado'>
<cfset destado[30] = 'Nota de Cr&eacute;dito'>
<cfset destado[40] = 'Nota de D&eacute;bito'>
<cfset destado[50] = 'Pagado'>
<cfset destado[60] = 'Anulado'>

<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr class="tituloListas" >
		<td><strong>Item</strong></td>
		<td align="right"><strong>Cant. Origen</strong></td>
		<td align="right"><strong>Cantidad</strong></td>
		<td align="right"><strong>Precio Origen</strong></td>
		<td align="right"><strong>Precio</strong></td>
		<td align="left"><strong>Estado</strong></td>
		<td align="center"><strong>Obs.</strong></td>
		<td align="center"><strong>Seg.</strong></td>
	</tr>

	<cfloop query="dataDReclamos">
		<input type="hidden" name="DRid_#dataDReclamos.CurrentRow#" value="#dataDReclamos.DRid#">
		<tr style="padding:2; " class="<cfif dataDReclamos.currentrow mod 2>listaNon<cfelse>listaPar</cfif>" >
			<td width="15%" nowrap>#dataDReclamos.DOdescripcion#</td>
			<td align="right" nowrap>#LSCurrencyFormat(dataDReclamos.DRcantorig,'none')#</td>
			<td align="right" nowrap>#LSCurrencyFormat(dataDReclamos.DRcantrec,'none')#</td>
			<td align="right" nowrap>#LvarOBJ_PrecioU.enCF_RPT(dataDReclamos.DRpreciooc)#</td>
			<td align="right" nowrap>#LvarOBJ_PrecioU.enCF_RPT(dataDReclamos.DRpreciorec)#</td>
			<td  width="1%" nowrap>
				<cfif dataDReclamos.DRestado eq 10>
					<select name="DRestado_#dataDReclamos.CurrentRow#">
						<option value="10" <cfif dataDReclamos.DRestado eq 10>selected</cfif> >En Proceso</option>
						<option value="20" <cfif dataDReclamos.DRestado eq 20>selected</cfif> >Producto Entregado</option>
						<option value="30" <cfif dataDReclamos.DRestado eq 30>selected</cfif> >Nota de Cr&eacute;dito</option>
						<option value="40" <cfif dataDReclamos.DRestado eq 40>selected</cfif> >Nota de D&eacute;bito</option>
						<option value="50" <cfif dataDReclamos.DRestado eq 50>selected</cfif> >Pagado</option>
						<option value="60" <cfif dataDReclamos.DRestado eq 60>selected</cfif> >Anulado</option>
					</select>
				<cfelse>
					#destado[dataDReclamos.DRestado]#
				</cfif>
			</td>
			<td align="center"><input type="hidden" name="DDRobsreclamo_#dataDReclamos.CurrentRow#" value="#dataDReclamos.DDRobsreclamo#"><img style="cursor: hand;" onClick="javascript:info_detalle('DDRobsreclamo_#dataDReclamos.CurrentRow#', <cfif DRestado neq 10>true<cfelse>false</cfif>)" src="../../imagenes/iedit.gif"></td>
			<td align="center"><img alt="Ver seguimiento para esta l&iacute;nea" style="cursor: hand;" onClick="javascript:seguimiento('#dataDReclamos.ERid#', '#dataDReclamos.DRid#')" src="../../imagenes/findsmall.gif"></td>
		</tr>
	</cfloop>
</table>

<!--- Ocultos --->
<input type="hidden" name="cantidad" value="#dataDReclamos.RecordCount#">

</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function info_detalle(name,readonly){
		open('reclamos-info.cfm?name='+name+'&readonly='+readonly, 'documentos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
	}
	function seguimiento(id, linea){
		location.href = '../catalogos/seguimiento.cfm?ERid='+id+'&DRid='+linea;
	}
</script>