<form action="" method="post" name="form1">
		<table width="100%" border="0" cellspacing="2" cellpadding="2" class="AreaFiltro">
			<tr>
				<td nowrap><strong>Mes : </strong></td>
				<td nowrap>
					<select name="AVmes">
						<cfloop query="rsMeses">
							<option value="#VSvalor#" 
								<cfif (not isdefined("Lvar_formMes") and rsMeses.VSvalor eq rsMes.Pvalor) or (isdefined("Lvar_formMes") and rsMeses.VSvalor eq Lvar_formMes)>
									selected
								</cfif>
							>#VSdesc#</option>
						</cfloop>
					</select>
				</td>
				<td nowrap>
					<select name="AVano">
						<cfloop from="#rsAno.Pvalor-3#" to="#rsAno.Pvalor+3#" index="value">
							<option value="#value#" 
									<cfif (not isdefined("Lvar_formAno") and value eq rsAno.Pvalor) or (isdefined("Lvar_formAno") and value eq Lvar_formAno)>
										selected
									</cfif>
							>#value#</option>
						</cfloop>
					</select>
				</td>
				<td nowrap><strong>Oficina : </strong></td>
				<td nowrap>
					<select name="Ocodigo">
						<option value="-1" >-todos-</option>
						<cfloop query="rsOficinas">
							<option value="#rsOficinas.Ocodigo#" 
								<cfif Lvar_Oficina neq -1 and rsOficinas.Ocodigo eq Lvar_Oficina>
									selected
								</cfif>
							>#rsOficinas.Odescripcion#</option>
						</cfloop>
					</select>
				</td>
				<td nowrap><strong>Variable : </strong></td>
				<td nowrap>
					<select name="AVid">
						<option value="-1" >-todos-</option>
						<cfloop query="rsVariables">
							<option value="#rsVariables.AVid#" 
								<cfif Lvar_Variable neq -1 and rsVariables.AVid eq Lvar_Variable>
									selected
								</cfif>
							>#rsVariables.AVnombre# - #rsVariables.AVdescripcioncorta#</option>
						</cfloop>
					</select>
				</td>
				<td nowrap><cf_botones values="Filtrar"></td>
			</tr>
		</table>
</form>