let showMessage = function(message_type, message){
  let messageHtml = '';

  if(message_type == 'notice'){
    messageHtml = '<div class="container mt-3">'+
                  ' <div class="alert alert-primary alert-dismissible fade show" role="alert">'+
                  '   <strong>Attention!</strong> '+message+
                  '   <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>'+
                  ' </div>'+
                  '</div>'
  }else if(message_type == 'alert'){
    messageHtml = '<div class="container mt-3">'+
                  ' <div class="alert alert-warning alert-dismissible fade show" role="alert">'+
                  '   <strong>Attention!</strong> '+message+
                  '   <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>'+
                  ' </div>'+
                  '</div>'
  }
  $('#alertContainer').html(messageHtml)
}

let getEntryHtml = function(name, entries){
  let entryHtml = ''
  entryHtml +=  '<span>'+name+'</span>'+
                '<table class="table">'+
                '<thead>'+
                '<tr>'+
                '<th scope="col">Description</th>'+
                '<th scope="col">Amount</th>'+
                '</tr>'+
                '</thead>'+
                '<tbody>';

  entries.forEach(function(entry){
    entryHtml += '<tr><td>'+entry.description+'</td><td>'+entry.amount+'</td></tr>'
  })

  entryHtml +=  '</tbody>'+
                  '</table>'

  return entryHtml
}

let getStatementHtml = function(response){
  let homeContent = '';
  homeContent +=  '<div class="row">'+
                  ' <div class="col-md-12">'+
                  '   <h3>'+response.ie_statement.name+'</h3>'

  homeContent += ieStatementModule.getEntryHtml('Income', response.income_entries)
  homeContent += ieStatementModule.getEntryHtml('Expenditure', response.expenditure_entries)
  homeContent += ieStatementModule.getEntryHtml('Debt Payments', response.debt_payment_entries)

  homeContent += '</div>'+
                 '</div>'

  homeContent += '<div class="row mt-3">'+
                 ' <div class="col-md-6">Disposable income:</div>'+
                 ' <div class="col-md-6">'+response.disposable_income+'</div>'+
                 '</div>'
  homeContent += '<div class="row mt-3">'+
                 ' <div class="col-md-6">IE Rating:</div>'+
                 ' <div class="col-md-6">'+response.ie_rating+'</div>'+
                 '</div>'

  return homeContent
}

let getStatementListHtml = function(statements){
  let listHtml = '';
  listHtml += '<h4>Previous Statements</h4>'+
              '<table class="table">'
  statements.forEach(function(statement){
    listHtml += '<tr>'+
                ' <td>'+statement.name+'</td>'+
                ' <td>'+
                '   <button type="button" data-statement-id="'+statement.id+'" class="btn btn-primary show-statement">'+
                '     Show'
                '   </button>'
                ' </td>'
                '</tr>'
  })

  listHtml += '</table>'

  return listHtml
}

let resetAddIEStatementForm = function(){
  const fieldContainers = ['incomeFieldsContainer', 'expenditureFieldsContainer', 'debtPaymentFieldsContainer']
  
  $('#addIeStatementModal').modal('hide')
  $('#addIEStatementForm').trigger('reset')
  $('#addIEStatementForm').removeClass('was-validated')

  fieldContainers.forEach(function(fieldContainer){
    $('#'+fieldContainer).html('')
  })

  document.getElementById('submitAddStatement').disabled = false;
}

export default {
  showMessage,
  getEntryHtml,
  getStatementHtml,
  getStatementListHtml,
  resetAddIEStatementForm
}