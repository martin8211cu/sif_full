<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="conlis" datasource="#Session.DSN#">
	select a.Mcodigo, b.Ccuenta, Dtipocambio, c.Cdescripcion, coalesce (b.Rcodigo, '%') as Rcodigo,
		   rtrim(b.CCTcodigo#_Cat#'-'#_Cat#rtrim(b.Ddocumento)#_Cat#'-'#_Cat#a.Mnombre) as Descripcion,
		   a.Mnombre, 
		   b.Dfecha, 
		   d.CCTcodigo, 
		   rtrim(b.Ddocumento) as Ddocumento,
		   b.Dsaldo,
		   (select min(pp.PPnumero)
		   	from PlanPagos pp
				where pp.Ecodigo = b.Ecodigo
				and pp.CCTcodigo = b.CCTcodigo
				and pp.Ddocumento = b.Ddocumento
				and pp.PPfecha_pago is null <!--- documentos sin pagar --->) as PPnumero,
			
			coalesce( (select pp.PPprincipal + pp.PPinteres
		   	from PlanPagos pp
				where pp.Ecodigo = b.Ecodigo
				and pp.CCTcodigo = b.CCTcodigo
				and pp.Ddocumento = b.Ddocumento
				and pp.PPfecha_pago is null <!--- documentos sin pagar --->
				group by Ecodigo,CCTcodigo,Ddocumento <!--- para que sirva / ase 12.5.1/EBF11428/WinNT --->
				having pp.PPnumero = min (pp.PPnumero)), 0) as MontoCuota,
			
			coalesce( (select pp.PPpagomora
		   	from PlanPagos pp
				where pp.Ecodigo = b.Ecodigo
				and pp.CCTcodigo = b.CCTcodigo
				and pp.Ddocumento = b.Ddocumento
				and pp.PPfecha_pago is null <!--- documentos sin pagar --->
				group by Ecodigo,CCTcodigo,Ddocumento <!--- para que sirva / ase 12.5.1/EBF11428/WinNT --->
				having pp.PPnumero = min (pp.PPnumero)),0) as InteresMora,
			
			(select pp.PPfecha_vence
		   	from PlanPagos pp
				where pp.Ecodigo = b.Ecodigo
				and pp.CCTcodigo = b.CCTcodigo
				and pp.Ddocumento = b.Ddocumento
				and pp.PPfecha_pago is null <!--- documentos sin pagar --->
				group by Ecodigo,CCTcodigo,Ddocumento <!--- para que sirva / ase 12.5.1/EBF11428/WinNT --->
				having pp.PPnumero = min (pp.PPnumero)) as PPfecha_vence,
				
				'' as codigo ,f.SNnombre
	from Documentos b
		inner join SNegocios f
			on b.Ecodigo=f.Ecodigo 
			and b.SNcodigo = f.SNcodigo
		inner join Monedas a
			on a.Mcodigo = b.Mcodigo 
 		inner join CContables c
			on b.Ccuenta = c.Ccuenta 
		inner join CCTransacciones d
			on b.Ecodigo = d.Ecodigo 
			and b.CCTcodigo = d.CCTcodigo 
			and d.CCTtipo = 'D'
			and coalesce(d.CCTpago,0) != 1
			and coalesce(d.CCTvencim,0) != -1
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	  and b.Dsaldo > 0 
	  and b.SNcodigo = 10020
	  
	  and not exists( select 1
	  				  from RCBitacora rcb
					  where rcb.Ddocumento = b.Ddocumento
					    and rcb.CCTcodigo = b.CCTcodigo
						and rcb.Ecodigo = b.Ecodigo
						and rcb.RCBestado=0 )

	order by b.Dfecha, b.Mcodigo, b.Dsaldo desc, b.CCTcodigo, b.Ddocumento 
</cfquery>

<table width="95%" cellpadding="2" cellspacing="0" align="center">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td align="center"><strong>Agregar Documentos para Reclasificaci&oacute;n</strong></td>
	</tr>
	
	<tr>
		<td>
			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#conlis#"/>
				<cfinvokeargument name="desplegar" value="CCTcodigo,Ddocumento,PPnumero,Mnombre,Dsaldo,MontoCuota,InteresMora,Dfecha,PPfecha_vence,SNnombre"/>
				<cfinvokeargument name="etiquetas" value="Transacci&oacute;n,Documento,Cuota,Moneda,Saldo,Cuota,Mora,Fecha,Fecha&nbsp;Pago,Socio&nbsp;de&nbsp;Negocios"/>
				<cfinvokeargument name="formatos" value="S,S,S,S,M,M,M,D,D,S"/>
				<cfinvokeargument name="align" value="left,left,left,left,left,left,left,left,left,left"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="keys" value="Ddocumento,CCTcodigo"/> 
				<cfinvokeargument name="showEmptyListMsg" value= "true"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="MaxRows" value="15"/>
				<cfinvokeargument name="navegacion" value=""/>
				<cfinvokeargument name="incluyeform" value="true">
				<cfinvokeargument name="ira" value="">
				<cfinvokeargument name="formname" value="lista"/>
				<cfinvokeargument name="funcion" value="Asignar"/>
				<cfinvokeargument name="fparams" value="Codigo,Descripcion,Ddocumento,CCTcodigo"/>
				<cfinvokeargument name="botones" value="Agregar"/>
				<cfinvokeargument name="showlink" value="false"/>
			</cfinvoke>
		</td>
	</tr>
</table>

