using System;
using System.Collections.Generic;
using System.Linq;

using Flurl.Http;

using OptimaJet.Workflow.Core.Model;
using OptimaJet.Workflow.Core.Runtime;

namespace WF.Server.Business
{
    public class WorkflowRule : IWorkflowRuleProvider
    {
        private class RuleFunction
        {
            public Func<ProcessInstance, string, IEnumerable<string>> GetFunction { get; set; }

            public Func<ProcessInstance, string, string, bool> CheckFunction { get; set; }
        }

        private readonly Dictionary<string, RuleFunction> _funcs =
            new Dictionary<string, RuleFunction>();


        public WorkflowRule()
        {
            _funcs.Add("CheckRole", new RuleFunction() { CheckFunction = CheckRole, GetFunction = GetInRole });
        }

        private IEnumerable<string> GetInRole(ProcessInstance processInstance, string parameter)
        {
            return new string[0];
        }

        private bool CheckRole(ProcessInstance processInstance, string identityId, string parameter)
        {
            var url = $"http://wfdoc:62001/api/demo/users/check-role?userName={identityId}&role={parameter}";
            return url.GetJsonAsync<bool>().Result;
        }

        public List<string> GetRules()
        {
            return _funcs.Select(c => c.Key).ToList();

        }


        public bool Check(ProcessInstance processInstance, WorkflowRuntime runtime, string identityId, string ruleName, string parameter)
        {
            return _funcs.ContainsKey(ruleName) && _funcs[ruleName].CheckFunction.Invoke(processInstance, identityId, parameter);
        }

        public IEnumerable<string> GetIdentities(ProcessInstance processInstance, WorkflowRuntime runtime, string ruleName, string parameter)
        {
            return !_funcs.ContainsKey(ruleName)
                ? new List<string> {}
                : _funcs[ruleName].GetFunction.Invoke(processInstance, parameter);
        }
    }
}
