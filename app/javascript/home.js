$( document ).ready(function() {
  (() => {
    'use strict'
  
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    const forms = document.querySelectorAll('.needs-validation')
  
    // Loop over them and prevent submission
    Array.from(forms).forEach(form => {
      form.addEventListener('submit', event => {
        if (!form.checkValidity()) {
          event.preventDefault()
          event.stopPropagation()
        }
  
        form.classList.add('was-validated')
      }, false)
    })
  })()

  let showMessage = function(message_type, message){
    let messageHtml = '';

    if(message_type == 'notice'){
      messageHtml = '<div class="container mt-3">'+
                    ' <div class="alert alert-primary alert-dismissible fade show" role="alert">'+
                    '   <strong>Attention!</strong>'+message+
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

    homeContent += getEntryHtml('Income', response.income_entries)
    homeContent += getEntryHtml('Expenditure', response.expenditure_entries)
    homeContent += getEntryHtml('Debt Payments', response.debt_payment_entries)

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

  const addIEStatementModal = document.getElementById('addIeStatementModal')
  
  addIEStatementModal.addEventListener('shown.bs.modal', event => {
    $(document).on('submit', '#addIEStatementForm', function(event){
      event.preventDefault()

        $.ajax({
          url: '/ie_statements',
          data: $(this).serialize(),
          method: 'POST'
        }).done(function(response){
          console.log(response)
          $('#addIeStatementModal').modal('hide')
          $('#addIEStatementForm').trigger('reset')

          if(response['success']){
            showMessage('notice', 'IE Statement created.')
            let homeContent = getStatementHtml(response)
            $('#homeContent').html(homeContent)
          }else{
            showMessage('alert', response.message)
          }

        }).fail(function(jqXHR, textStatus, errorThrown){
          console.log(errorThrown);
          showMessage('alert', errorThrown)
          $('#addIeStatementModal').modal('hide')
          $('#addIEStatementForm').trigger('reset')
        })
      
    })
  })

  $(document).on('click', '#addMoreIncome', function(){
    $('#incomeFieldsContainer').append($('#incomeField').html())
  })

  $(document).on('click', '#addMoreExpenditure', function(){
    $('#expenditureFieldsContainer').append($('#expenditureField').html())
  })

  $(document).on('click', '#addMoreDebtPayment', function(){
    $('#debtPaymentFieldsContainer').append($('#debtPaymentField').html())
  })

  $(document).on('click', '.field-close', function(){
    $(this).parent().parent().empty()
  })
});