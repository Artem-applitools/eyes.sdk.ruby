# frozen_string_literal: true
#
module Applitools::Selenium
  module DomCapture
    CSS_CAPTURE_SCRIPT = <<-SCRIPT
      function extractCssResources() {
        return Array.from(document.querySelectorAll('link[rel="stylesheet"],style')).map(el => {
          if (el.tagName.toUpperCase() === 'LINK') {
              return {"href": el.getAttribute('href')};
          } else {
              return {"text": el.textContent};
          }
        });
      }
      return extractCssResources();
    SCRIPT
    DOM_CAPTURE_SCRIPT = <<-SCRIPT
    function captureFrame({styleProps, attributeProps, rectProps, ignoredTagNames}) {
      const NODE_TYPES = {
          ELEMENT: 1,
          TEXT: 3,
      };

      function filter(x) {
        return !!x;
      }

      function notEmptyObj(obj) {
        return Object.keys(obj).length ? obj : undefined;
      }

      function iframeToJSON(el) {
        const obj = elementToJSON(el);
        try {
          if (el.contentDocument) {
              obj.childNodes = [captureNode(el.contentDocument.documentElement)];
          }
          } catch (ex) {
          } finally {
            return obj;
          }
          }

          function elementToJSON(el) {
            const tagName = el.tagName.toUpperCase();
            if (ignoredTagNames.indexOf(tagName) > -1) return null;
            const computedStyle = window.getComputedStyle(el);
            const boundingClientRect = el.getBoundingClientRect();

            const style = {};
            for (const p of styleProps) style[p] = computedStyle.getPropertyValue(p);

            const rect = {};
            for (const p of rectProps) rect[p] = boundingClientRect[p];

            const attributes = {};
            if (attributeProps.all) {
                for (const p of attributeProps.all) {
                    if (el.hasAttribute(p)) attributes[p] = el.getAttribute(p);
                    }
                    }

                    if (attributeProps[tagName]) {
                        for (const p of attributeProps[tagName]) {
                            if (el.hasAttribute(p)) attributes[p] = el.getAttribute(p);
                            }
                            }

                            return {
                                tagName,
                                style: notEmptyObj(style),
                                rect: notEmptyObj(rect),
                                attributes: notEmptyObj(attributes),
                                childNodes: Array.prototype.map.call(el.childNodes, captureNode).filter(filter),
                            };
                            }

                            function captureTextNode(node) {
                              return {
                                  tagName: '#text',
                                  text: node.textContent,
                              };
                            }

                            function captureNode(node) {
                              switch (node.nodeType) {
                                case NODE_TYPES.TEXT:
                                    return captureTextNode(node);
                                case NODE_TYPES.ELEMENT:
                                    if (node.tagName.toUpperCase() === 'IFRAME') {
                                        return iframeToJSON(node);
                                    } else {
                                        return elementToJSON(node);
                                    }
                                    default:
                                        return null;
                                    }
                                    }

                                    return captureNode(document.documentElement);
                                    }

                                    return captureFrame(arguments[0]);
    SCRIPT
  end
end
