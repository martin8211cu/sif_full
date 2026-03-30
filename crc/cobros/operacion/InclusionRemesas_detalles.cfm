<cfset navegacion = "">
<cf_dbfunction name="OP_concat" returnvariable="cat">
<cfquery name="docsSinIncluir" datasource="#session.dsn#">

select     'Cheques'  as Origen,
                FPdocnumero as Cheque,
                FPmontoori  as MontoCheque,                    
                m.Msimbolo,
                m.Miso4217,                 
                m.Mcodigo,
                FPlinea,
                '1' as Dtipo,
                a.ETnumero,
                FPfechapago,
                a.FCid,
                null as CCTcodigo, null as Pcodigo
            from FPagos a
            inner join Monedas m
              on  a.Mcodigo = m.Mcodigo       
            inner join ETransacciones et
                on a.ETnumero = et.ETnumero
                and a.FCid = et.FCid                        
           where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsform.Mcodigo#">
              and et.FACid IS NULL 
               <cfif isdefined("LvarNumLote")>
                 and et.ETestado = 'T'
              <cfelse> 
              and et.FCid = #session.Caja#
               and et.ETestado = 'C'
              </cfif>
              and a.Tipo = 'C'                       
              and a.ERid is null 
                <cfif isdefined ('LvarNumLote')>
              and et.ETlote = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarNumLote#">
              </cfif> 
        union all
        select  'Cheques' as Origen ,
                FPdocnumero as Cheque,
                FPmontoori  as MontoCheque,                    
                m.Msimbolo,
                m.Miso4217,                 
                m.Mcodigo,
                FPlinea,
                '2' as Dtipo,
                null as ETnumero,
                FPfechapago, 
                null as FCid,
                a.CCTcodigo,
                a.Pcodigo
          from PFPagos a 
            inner join #LvarTabla# p
                on a.CCTcodigo = p.CCTcodigo
                and a.Pcodigo = p.Pcodigo    
            inner join Monedas m
                on a.Mcodigo = m.Mcodigo              
           where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsform.Mcodigo#">
             and p.FACid IS NULL
              <cfif isdefined("LvarNumLote")>
              <cfelse>
             and p.FCid = #session.Caja#
             </cfif>
             and a.Tipo = 'C' 
             and a.ERid is null
               <cfif isdefined ('LvarNumLote')>
             and p.Plote = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarNumLote#">
             </cfif>                           
	
</cfquery>

<cfquery name="docsIncluidos" datasource="#session.dsn#">

select     'Cheques'  as Origen,
                FPdocnumero as Cheque,
                FPmontoori  as MontoCheque,                    
                m.Msimbolo,
                m.Miso4217,                 
                m.Mcodigo,
                FPlinea,
                '1' as Dtipo,
                a.ETnumero,
                FPfechapago,
                a.FCid,
                null as CCTcodigo, null as Pcodigo
            from FPagos a
            inner join Monedas m
              on  a.Mcodigo = m.Mcodigo       
            inner join ETransacciones et
                on a.ETnumero = et.ETnumero
                and a.FCid = et.FCid                        
           where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsform.Mcodigo#">
              and et.FACid IS NULL 
               <cfif isdefined("LvarNumLote")>
                 and et.ETestado = 'T'
              <cfelse>
                and et.ETestado = 'C'
              and et.FCid = #session.Caja#
              </cfif>
              and a.Tipo = 'C'                       
              and a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
                 <cfif isdefined ('LvarNumLote')>
             and et.ETlote = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarNumLote#">
             </cfif> 
        union all
        select  'Cheques' as Origen ,
                FPdocnumero as Cheque,
                FPmontoori  as MontoCheque,                    
                m.Msimbolo,
                m.Miso4217,                 
                m.Mcodigo,
                FPlinea,
                '2' as Dtipo,
                null as ETnumero, 
                FPfechapago,
                null as FCid,
                a.CCTcodigo,
                a.Pcodigo
          from PFPagos a 
            inner join #LvarTabla# p
                on a.CCTcodigo = p.CCTcodigo
                and a.Pcodigo = p.Pcodigo    
            inner join Monedas m
                on a.Mcodigo = m.Mcodigo              
           where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsform.Mcodigo#">
             and p.FACid IS NULL
              <cfif isdefined("LvarNumLote")>
              <cfelse>
             and p.FCid = #session.Caja#
             </cfif>
             and a.Tipo = 'C' 
             and a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
            <cfif isdefined ('LvarNumLote')>
             and p.Plote = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarNumLote#">
             </cfif> 

</cfquery>

<cfoutput>
<form action="SQLInclusionRemesas.cfm" method="post" name="form2"> 
	<input type="hidden" name="ERid" value="#rsForm.ERid#" />
    <input type="hidden" name="Mcodigo" value="#rsForm.Mcodigo#" />
    <input type="hidden" name="Bid" value="#rsForm.Bid#" />
    <input type="hidden" name="CBid" value="#rsForm.CBid#" />
    <input type="hidden" name="NumDeposito" value="#rsform.NumDeposito#" />
    <input type="hidden" name="Fremesa" value="#rsform.Fremesa#" />
    <cfif isdefined ('LvarNumLote')>
    <input type="hidden" name="NumLote" value="#LvarNumLote#" />
    </cfif>
    
    
	<cfset LvarMonto=0>
	<table width="100%" border="1">
		<tr>
			<td width="50%" valign="top" align="left">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr class="tituloListas">
						<td colspan="12" class="tituloListas" align="center">Lista de Cheques</td>
					</tr>
					<tr class="tituloListas">
						<td align="center" colspan="12">
						<input type="submit" value="Agregar" name="btnAgrega"
						  <cfif docsSinIncluir.RecordCount eq 0>disabled</cfif>
							/>
						</td>
					</tr>
					<tr class="tituloListas">
                     <td width="1%"><input type="checkbox" name="chkAll" onClick="javascript: checkAll(this.form);"></td>
						<td width="1%" align="center">&nbsp;</td>
						<td nowrap><strong>Tipo Doc.</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td nowrap><strong>Documento</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td align="center" nowrap><strong>Descripción</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td nowrap align="center"><strong>Fecha</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td width="1%" align="center">&nbsp;</td>
						<td align="center" nowrap><strong>Monto</strong></td>
					</tr>
						<cfif docsSinIncluir.RecordCount gt 0>
							<cfloop query="docsSinIncluir">
					<tr class="<cfif docsSinIncluir.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td valign="middle" align="center"><input type="checkbox" name="agr" id="agr" value="#docsSinIncluir.DTipo#|#docsSinIncluir.Cheque#|#docsSinIncluir.ETnumero#|#docsSinIncluir.CCTcodigo#|#docsSinIncluir.Pcodigo#"></td>
                        <td width="1%" align="center">&nbsp;</td>
						<td valign="right" align="left">&nbsp; &nbsp;&nbsp; #docsSinIncluir.DTipo#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td valign="right" align="left">#docsSinIncluir.Cheque#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td align="left" valign="middle">#docsSinIncluir.Origen#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td valign="middle" align="left">#LSDateFormat(docsSinIncluir.FPfechapago, 'dd/mm/yyyy')#</td>
						<td width="1%" align="right">&nbsp;</td>
						<td width="1%" align="right">&nbsp;</td>
						<td valign="middle" align="right">#NumberFormat(docsSinIncluir.MontoCheque,",0.00")#</td>
					</tr>	
							<cfset LvarMonto=LvarMonto+docsSinIncluir.MontoCheque>
							</cfloop>
						<cfelse>
					<tr><td colspan="5" align="center"><strong> - No existen cheques asignados a esta caja - </strong></td></tr>
						</cfif>		
				</table>	
			</td>
			<td width="50%"  align="left" valign="top">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr class="tituloListas">
						<td colspan="12" class="tituloListas" align="center">Lista de Cheques a Incluir en la remesa</td>
					</tr>
					<tr class="tituloListas">
						<td align="center" colspan="12">
                            <input type="submit" value="Eliminar" name="btnElimina" 
								<cfif docsIncluidos.RecordCount eq 0>disabled</cfif>
							/>
						</td>
					</tr>
					<tr class="tituloListas">
                    <td width="1%"><input type="checkbox" name="chkAllE" onClick="javascript: checkAllE(this.form);"></td>
						<td width="1%" align="center">&nbsp;</td>
						<td nowrap><strong>Tipo Doc.</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td nowrap><strong>Documento</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td align="center" nowrap><strong>Descripción</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td nowrap align="center"><strong>Fecha</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td width="1%" align="center">&nbsp;</td>
						<td align="center" nowrap><strong>Monto</strong></td>
					</tr>
						<cfif docsIncluidos.RecordCount gt 0>
							<cfloop query="docsIncluidos">
					<tr class="<cfif docsIncluidos.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td valign="middle" align="center"><input type="checkbox" name="eli" value="#docsIncluidos.DTipo#|#docsIncluidos.Cheque#"></td>
                        <td width="1%" align="center">&nbsp;</td>
						<td valign="middle" align="left">&nbsp; &nbsp;&nbsp;#docsIncluidos.DTipo#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td valign="middle" align="left">#docsIncluidos.Cheque#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td align="left" valign="middle">#docsIncluidos.Origen#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td valign="middle" align="left">#LSDateFormat(docsIncluidos.FPfechapago, 'dd/mm/yyyy')#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td width="1%" align="center">&nbsp;</td>
						<td valign="middle" align="right">#NumberFormat(docsIncluidos.MontoCheque,",0.00")#</td>
					</tr>
							</cfloop>
						<cfelse>
					<tr><td colspan="5" align="center"><strong> - No existen cheques asignadas a esta caja - </strong></td></tr>
						</cfif>		
				</table>	
			</td>
		</tr>
	</table>
</form>

<script language="javascript" type="text/javascript">
		function checkAll(f) {
		if (f.agr != null) {
			if (f.agr.value != null) {
				if (!f.agr.disabled) f.agr.checked = f.chkAll.checked;
			} else {
				for (var i=0; i<f.agr.length; i++) {
					if (!f.agr[i].disabled) f.agr[i].checked = f.chkAll.checked;
				}
			}
		}
	}
	
	function checkAllE(f) {
		if (f.eli != null) {
			if (f.eli.value != null) {
				if (!f.eli.disabled) f.eli.checked = f.chkAllE.checked;
			} else {
				for (var i=0; i<f.eli.length; i++) {
					if (!f.eli[i].disabled) f.eli[i].checked = f.chkAllE.checked;
				}
			}
		}
	}
</script>

</cfoutput>

