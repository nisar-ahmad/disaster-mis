using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ODTKMS.ViewModels
{
    public class CheckBoxItem
    {
        public string Text { get; set; }
        public int Value { get; set; }
        
        public bool Selected { get; set; }
    }
}